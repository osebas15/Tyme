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
        
        @Attribute(.unique) var id: UUID
        
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
        
        //var currentStep: Int
        private var innerCurrentStep: ActivityObject?
        @Transient var currentStep: ActivityObject{
            get{
                return firstStep.innerCurrentStep ?? firstStep
            }
            set {
                firstStep.innerCurrentStep = newValue
            }
        }
        
        private var _firstStep: ActivityObject?
        @Transient var firstStep: ActivityObject {
            get {
                _firstStep ?? self
            }
            set {
                _firstStep = newValue
            }
        }
        
        var activityClass : ActivityClass?
        var startDate: Date?
        var completionDate: Date?
        var onOffTimes: [TimeRange]?
        
        var priorityOrder: Int
        
        private var storedFocus: Int
        @Transient var focus: FocusState{
            set{ self.storedFocus = newValue.rawValue }
            get{ return FocusState(rawValue: storedFocus) ?? .error }
        }
        
        init(
            activityClass: ActivityClass,
            startDate: Date? = nil,
            onOffTimes: [TimeRange]? = nil,
            subActivities: [ActivityObject] = [],
            focus: FocusState = .waitingToStart,
            priorityOrder: Int? = nil,
            firstStep: ActivityObject? = nil,
            id: UUID? = nil
        ) {
            self.activityClass = activityClass
            self.startDate = startDate
            self.onOffTimes = onOffTimes
            self.subActivities = subActivities
            self.storedFocus = focus.rawValue
            self.priorityOrder = priorityOrder ?? 0
            self._firstStep = firstStep
            self.id = id ?? UUID()
        }
    }
}

extension ActivityObject {
    enum FocusState: Int { case waitingToStart, started, inSubsteps, done, overdue, error }
}

extension ActivityObject {
    @Transient var creationDate: Date?{
        get { return onOffTimes?.first?.start }
    }
    @Transient var hasNext: Bool{
        get {
            if let actClass = self.activityClass {
                return actClass.stepAfter(origClass: actClass) != nil
            }
            else {
                return false
            }
        }
    }
    @Transient var numberOfSubActivities: Int {
        get { return activityClass?.unOrderedSubActivities.count ?? 0 }
    }
    @Transient var isPartOfMultiPick: Bool {
        get { return parent?.activityClass?.unOrderedSubActivities.count ?? 0 > 1 }
    }
    @Transient var timeLeftToWait: TimeInterval? {
        get {
            guard
                let waitTime = activityClass?.waitAfterCompletion,
                let startDate = startDate
            else { return nil }
            
            return waitTime + startDate.timeIntervalSinceNow
        }
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
            let startDate = self.startDate,
            let waitUntil = self.activityClass?.waitAfterCompletion
        {
            return startDate.addingTimeInterval(waitUntil)
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
        priorityIndex: Int? = nil
    ){
        if let priorityIndex = priorityIndex {
            unOrderedActivities
                .filter{ $0.priorityOrder >= priorityIndex }
                .forEach{ $0.priorityOrder += 1 }
        }
        
        let newObject = ActivityObject(
            activityClass: activityClass,
            focus: .waitingToStart,
            priorityOrder: priorityIndex ?? self.subActivities.count
        )
        
        context.insert(newObject)
        self.subActivities.append(newObject)
        
        //start the subactivities from the activityclass
        if let activityClass = newObject.activityClass, activityClass.unOrderedSubActivities.count > 0 {
            if activityClass.unOrderedSubActivities.count > 1 {
                activityClass.orderedSubActivities.enumerated().forEach {
                    $1.start(context: context, parentObject: newObject, priorityIndex: $0)
                }
            }
            else {
                activityClass.unOrderedSubActivities[0].start(context: context, parentObject: newObject)
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
        if startDate != nil {
            if completionDate != nil {
                if firstStep == self && !activityClass!.orderedSteps.isEmpty{
                    return .inSubsteps
                }
                else {
                    return .done
                }
            }
            else {
                if activityClass?.waitAfterCompletion == nil || timeLeftToWait! > 0 {
                    return .started
                }
                return .overdue
            }
        }
        else {
            return .waitingToStart
        }
    }
    /*
    func checkAndContinueState(
        context: ModelContext,
        timerManager: TimerManager,
        userAction: Bool = true)
    {
        let verifiedState = verifyCurrentState()
        
        .inSubsteps.done.started.waitingToStart
        
        switch verifiedState{
        case .inSubsteps:
            self.focus = .done
            //done(context: context)//TODO: make sure there are not timers for this class
        case .passive:
            self.focus = .passive
            createWaitOnCompletionTimer(container: context.container, timerManager: timerManager)
            sendWaitOnCompleteNotification()
        case .actionable, .main:
            if userAction {
                startDate = Date()
                checkAndContinueState(context: context, timerManager: timerManager)
            }
        default:
            break
        }
        try? context.save()
    }
    */
    func getNextStep(context: ModelContext, nextStep: ActivityClass? = nil) -> ActivityObject?{
        let isFirstStep = self == firstStep
        guard isFirstStep, self.activityClass?.orderedSteps.count != 0 else {
            return nil
        }
        
        let currentStepClass = firstStep.currentStep.activityClass
        let nextClass = nextStep ??
            (
                currentStepClass != nil ?
                firstStep.activityClass?.stepAfter(origClass: currentStepClass!) :
                nil
            )
        
        if let next = nextClass {
            let newStep = ActivityObject(activityClass: next, priorityOrder: 0, firstStep: firstStep)
            return newStep
        }
        else {
            return ActivityObject.error()
        }
    }
    
    func start(){
        startDate = Date()
    }
    
    //make it simple end function for now
    func complete(context: ModelContext){
        if startDate == nil {
            start()
        }
        
        completionDate = Date()
        
        if let newStep = getNextStep(context: context){
            newStep.firstStep = firstStep
            firstStep.currentStep = newStep
        }
    }
    
    /*
    func done(context: ModelContext){
        guard let parent = parent else { return }
        
        if let next = activityClass?.next {
            parent.removeSubActivity(context: context, activity: self)
            next.start(context: context, parentObject: parent, priorityIndex: self.priorityOrder)
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
    }*/
}

extension ActivityObject {
    /*
    func createWaitOnCompletionTimer(
        container: ModelContainer,
        timerManager: TimerManager
    ){
        let persistantId = self.persistentModelID
        let waitTime = self.activityClass?.waitAfterCompletion
        let startDate = self.startDate
        
        Task{
            if await timerManager.timerExists(id: persistantId){
                await timerManager.endTimer(id: persistantId)
            }
            
            guard
                let startDate = startDate,
                let waitTime = waitTime
            else { return }
            
            Task {
                await timerManager.createTimer(for: TimerManager.TimerVariables(
                    fireInterval: waitTime - Date().timeIntervalSince(startDate),
                    id: persistantId,
                    action: {
                        Task {
                            await MainActor.run {
                                let actorIsolatedObject = ModelHelper().queriedCopy(container: container, id: persistantId)
                                actorIsolatedObject.checkAndContinueState(
                                    context: container.mainContext,
                                    timerManager: timerManager
                                )
                                try? container.mainContext.save()
                            }
                            await timerManager.endTimer(id: persistantId)
                        }
                    }
                ))
            }
        }
    }
     */
    
    func sendWaitOnCompleteNotification(){
        guard
            let activityClass = activityClass,
            let timeLeftToWait = timeLeftToWait
        else { return }
        
        let manager = TymeNotificationManager()
        
        let notificationInfo = TymeNotificationManager.NotificationInfo(
            title: activityClass.name,
            subtitle: activityClass.detail ?? "",
            timeToWait: timeLeftToWait,
            id: self.id
        )
        Task {
            await manager.sendWaitAfterCompletionDoneNotification(info: notificationInfo)
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
        return ActivityObject(activityClass: ActivityClass.dummyActivity(), priorityOrder: 0, id: UUID(uuidString: "ef2a0677-920b-4011-831a-e39f898d2b93"))
    }
    
    static func error() -> ActivityObject {
        return ActivityObject(activityClass: ActivityClass.error(), priorityOrder: 0, id: UUID(uuidString:"91802742-c4de-4170-bbe1-ec780981ca7a"))
    }
}
