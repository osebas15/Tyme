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
        
        @Relationship(
            deleteRule: .cascade,
            inverse: \ActivityObject.parent
        ) var subActivities: [ActivityObject]
        var parent: ActivityObject?
        
        var activityClass : ActivityClass?
        var completionDate: Date?
        var onOffTimes: [TimeRange]?
        
        var priorityOrder: Int
        @Transient var orderedActivities: [ActivityObject] {
            get { return subActivities.sorted { $0.priorityOrder < $1.priorityOrder }}
        }
        @Transient var unOrderedActivities: [ActivityObject] {
            get{ subActivities }
        }
        
        private var storedFocus: Int
        @Transient var focus: FocusState{
            set{ self.storedFocus = newValue.rawValue }
            get{ return FocusState(rawValue: storedFocus) ?? .error }
        }
        
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
        
        init(
            activityClass: ActivityClass,
            completionDate: Date? = nil,
            onOffTimes: [TimeRange]? = nil,
            subActivities: [ActivityObject] = [],
            focus: FocusState = .none,
            priorityOrder: Int
        ) {
            self.activityClass = activityClass
            self.completionDate = completionDate
            self.onOffTimes = onOffTimes
            self.subActivities = subActivities
            self.storedFocus = focus.rawValue
            self.priorityOrder = priorityOrder
        }
    }
}

extension ActivityObject {
    enum FocusState: Int { case main, passive, secondary, done, none, error }
    @MainActor static let error = ActivityObject(activityClass: ActivityClass.error, priorityOrder: 0)
}

extension ActivityObject {
    func createSubActivity(context: ModelContext, activityClass: ActivityClass, mainSubActivity: Bool = false){
        
        let newObject = ActivityObject(activityClass: activityClass, priorityOrder: self.subActivities.count )
        
        if mainSubActivity {
            self.subActivities.forEach{ $0.priorityOrder = $0.priorityOrder + 1 }
            newObject.priorityOrder = 0
        }
        
        context.insert(newObject)
        self.subActivities.append(newObject)
        
        //start the subactivities from the activityclass
        if let activityClass = newObject.activityClass, activityClass.unOrderedSubActivities.count > 0 {
            if activityClass.unOrderedSubActivities.count > 1 {
                activityClass.unOrderedSubActivities.forEach { $0.start(context: context, parentObject: newObject) }
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
    
    func done(context: ModelContext){
        guard let parent = parent else { return }
        if let next = activityClass?.next {
            parent.removeSubActivity(context: context, activity: self)
            next.start(context: context, parentObject: parent)
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
    static func dummyObject() -> ActivityObject {
        return ActivityObject(activityClass: ActivityClass.dummyActivity(), priorityOrder: 0)
    }
}
