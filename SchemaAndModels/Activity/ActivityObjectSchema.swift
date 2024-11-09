//
//  ActivityObject.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 7/27/24.
//

import Foundation
@preconcurrency import SwiftData
import SwiftUI

typealias ActivityObject = ActivityObject0_0_0.ActivityObject

enum ActivityObject0_0_0: VersionedSchema {
    static let models: [any PersistentModel.Type] = [ActivityObject.self]
    
    static let versionIdentifier = Schema.Version(0, 0, 0)
    
    @Model
    class ActivityObject: Identifiable {
        
        @Attribute(.unique) var id = UUID()
        
        var parent: ActivityObject?
        @Relationship(
            deleteRule: .cascade,
            inverse: \ActivityObject.parent
        ) private var subActivities: [ActivityObject]
        @Transient var orderedActivities: [ActivityObject] {
            get { return subActivities.sorted { $0.priorityOrder < $1.priorityOrder }}
        }
        @Transient var unOrderedActivities: [ActivityObject] {
            get{ subActivities }
        }
        
        var activityClass : ActivityClass?
        var completionDate: Date?
        var onOffTimes: [TimeRange]?
        
        var priorityOrder: Int
        
        var currentStep: Int
        
        private var storedFocus: Int
        @Transient var focus: FocusState{
            set{ self.storedFocus = newValue.rawValue }
            get{ return FocusState(rawValue: storedFocus) ?? .error }
        }
        
        init(
            activityClass: ActivityClass,
            completionDate: Date? = nil,
            onOffTimes: [TimeRange]? = nil,
            subActivities: [ActivityObject] = [],
            focus: FocusState = .none,
            priorityOrder: Int,
            currentStep: Int = 0
        ) {
            self.activityClass = activityClass
            self.completionDate = completionDate
            self.onOffTimes = onOffTimes
            self.subActivities = subActivities
            self.storedFocus = focus.rawValue
            self.priorityOrder = priorityOrder
            self.currentStep = currentStep
        }
    }
}

extension ActivityObject {
    enum FocusState: Int { case main, actionable, passive, done, none, error }
}

extension ActivityObject {
    @Transient var creationDate: Date?{
        get { return onOffTimes?.first?.start }
    }
    @Transient var hasNext: Bool{
        get { return activityClass?.next != nil }
    }
    @Transient var numberOfSubActivities: Int {
        get { return activityClass?.unOrderedSubActivities.count ?? 0 }
    }
    @Transient var isPartOfMultiPick: Bool {
        get { return parent?.activityClass?.unOrderedSubActivities.count ?? 0 > 1 }
    }
    @Transient var couldBeDone: Bool {
        get {
            for activity in subActivities {
                if activity.focus != .done{
                    return false
                }
            }
            return true
        }
    }
    @Transient var waitUntilDate: Date? {
        if
            let completionDate = self.completionDate,
            let waitUntil = self.activityClass?.waitAfterCompletion
        {
            return completionDate.addingTimeInterval(waitUntil)
        }
        else {
            return nil
        }
    }
    @Transient var lowestActivities: [ActivityObject]{
        if unOrderedActivities.isEmpty{
            return [self]
        }
        else {
            return orderedActivities.flatMap { $0.lowestActivities }
        }
    }
}

@MainActor
extension ActivityObject {
    func createSubActivity(
        context: ModelContext,
        activityClass: ActivityClass,
        priorityIndex: Int? = nil,
        stepNumber: Int
    ){
        if let priorityIndex = priorityIndex {
            unOrderedActivities
                .filter{ $0.priorityOrder >= priorityIndex }
                .forEach{ $0.priorityOrder += 1 }
        }
        
        let newObject = ActivityObject(
            activityClass: activityClass,
            focus: .actionable,
            priorityOrder: priorityIndex ?? self.subActivities.count,
            currentStep: stepNumber
        )
        
        context.insert(newObject)
        self.subActivities.append(newObject)
        
        //start the subactivities from the activityclass
        if let activityClass = newObject.activityClass, activityClass.unOrderedSubActivities.count > 0 {
            if activityClass.unOrderedSubActivities.count > 1 {
                activityClass.orderedSubActivities.enumerated().forEach {
                    $1.start(context: context, parentObject: newObject, priorityIndex: $0, stepNumber: 0)
                }
            }
            else {
                activityClass.unOrderedSubActivities[0].start(context: context, parentObject: newObject, stepNumber: 0)
            }
        }
    }
    
    func removeSubActivity(context: ModelContext, activity: ActivityObject){
        self.subActivities
            .filter{ $0.priorityOrder > activity.priorityOrder }
            .forEach{ $0.priorityOrder = $0.priorityOrder - 1 }
        
        if let position = subActivities.firstIndex(where: { $0.id == activity.id }){
            subActivities.remove(at: position)
            context.delete(activity)
        }
    }
    
    func verifyCurrentState() -> FocusState {
        if
            let completionDate = self.completionDate,
            let waitTime = self.activityClass?.waitAfterCompletion
        {
            if completionDate.addingTimeInterval(waitTime) <= Date(){
                return .done
            }
            else {
                return .passive
            }
        }
        else if self.completionDate != nil
        {
            return .done
        }
        else
        {
            return .actionable
        }
    }
    
    func checkAndContinueState(context: ModelContext, timerManager: TimerManager) {
        
        let verifiedState = verifyCurrentState()
        
        switch verifiedState{
        case .done:
            self.focus = .done
            done(context: context)
            return //TODO: make sure there are not timers for this class
        case .passive:
            self.focus = .passive
            checkForAndCreateIfMissingTimerForWaitOnCompletion(container: context.container, timerManager: timerManager)
        case .actionable, .main:
            completionDate = Date()
            checkAndContinueState(context: context, timerManager: timerManager)
        default:
            return
        }
    }
    
    func done(context: ModelContext){
        guard let parent = parent else { return }
        
        if let next = activityClass?.next {
            parent.removeSubActivity(context: context, activity: self)
            next.start(context: context, parentObject: parent, priorityIndex: self.priorityOrder, stepNumber: self.currentStep + 1)
        }
        else if isPartOfMultiPick {
            self.focus = .done
            if parent.couldBeDone{
                parent.removeSubActivity(context: context, activity: self)
                parent.done(context: context)
            }
        }
        else {
            parent.removeSubActivity(context: context, activity: self)
            parent.done(context: context)
        }
    }
}

extension ActivityObject {
    func checkForAndCreateIfMissingTimerForWaitOnCompletion(
        container: ModelContainer,
        timerManager: TimerManager
    ){
        let id = self.id
        let persistantId = self.persistentModelID
        Task{
            if await timerManager.timerExists(id: id ) {
                return
            }
        }
        
        guard
            let activityClass = self.activityClass,
            let completionDate = self.completionDate,
            let waitTime = activityClass.waitAfterCompletion
        else { return }
        
        Task {
            await timerManager.createTimer(for: TimerManager.TimerVariables(
                fireInterval: waitTime - completionDate.timeIntervalSince(Date()),
                id: id,
                action: {
                    Task {
                        await MainActor.run {
                            let actorIsolatedObject = ModelHelper().queriedCopy(container: container, persistantId: persistantId)
                            actorIsolatedObject.checkAndContinueState(
                                context: container.mainContext,
                                timerManager: timerManager
                            )
                        }
                        await timerManager.endTimer(id: id)
                    }
                }
            ))
        }
    }
}

extension ActivityObject {
    func getPlaceInPriorityHierarchy() -> String {
        if let parent = parent{
            return parent.getPlaceInPriorityHierarchy() + ", \(priorityOrder)"
        }
        else {
            return "\(priorityOrder)"
        }
    }
}

extension ActivityObject {
    
    static func dummyObject() -> ActivityObject {
        return ActivityObject(activityClass: ActivityClass.dummyActivity(), priorityOrder: 0)
    }
    
    static func error() -> ActivityObject {
        return ActivityObject(activityClass: ActivityClass.error(), priorityOrder: 0)
    }
}
