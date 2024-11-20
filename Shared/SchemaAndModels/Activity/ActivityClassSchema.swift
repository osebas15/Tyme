//
//  Activity.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 7/7/24.
//

import Foundation
import SwiftUI
@preconcurrency import SwiftData

typealias ActivityClass = ActivityClass0_0_0.ActivityClass

enum ActivityClass0_0_0: VersionedSchema {
    static let models: [any PersistentModel.Type] = [ActivityClass.self]
    
    static let versionIdentifier: Schema.Version = Schema.Version(0,0,0)
    
    @Model
    class ActivityClass: Identifiable{
        
        @Attribute(.unique) var id = UUID()
        
        @Relationship(
            deleteRule: .cascade,
            inverse: \ActivityObject.activityClass
        ) var objects: [ActivityObject] = []
        
        @Relationship(
            deleteRule: .nullify,
            inverse: \ActivityClass.previous
        ) var next: ActivityClass?
        var previous: ActivityClass?
        
        private var subActivities: [ActivityClass]
        var subActivityOrder: [Int: UUID]
        @Transient var orderedSubActivities: [ActivityClass] {
            get {
                var toReturn = [ActivityClass]()
                for index in 0..<subActivities.count {
                    let actClass = subActivities.first { $0.id == subActivityOrder[index] }!
                    toReturn.append(actClass)
                }
                return toReturn
            }
        }
        @Transient var unOrderedSubActivities: [ActivityClass] {
            get { return subActivities }
        }
        
        var name: String
        var detail: String?
        var timeToComplete: TimeInterval?
        var waitAfterCompletion: TimeInterval?
        
        var storedPriority: Int
        @Transient var priority: Priority {
            get { return Priority(rawValue: storedPriority) ?? .null }
            set { storedPriority = newValue.rawValue }
        }
        
        init(
            name: String?,
            next: ActivityClass? = nil,
            timeToComplete: TimeInterval? = nil,
            waitAfterCompletion: TimeInterval? = nil,
            detail: String? = nil,
            priority: Priority = .null
        ){
            self.name = name ?? ""
            self.detail = detail
            self.next = next
            self.subActivities = []
            self.subActivityOrder = [:]
            self.waitAfterCompletion = waitAfterCompletion
            self.timeToComplete = timeToComplete
            self.storedPriority = priority.rawValue
        }
    }
}

extension ActivityClass {
    enum Priority: Int { case immidiate, high, medium, low, passive, null }
}

extension ActivityClass {
    func addSubActivity(activity: ActivityClass){
        self.subActivityOrder[self.subActivityOrder.count] = activity.id
        self.subActivities.append(activity)
    }
    
    func addSteps(activities: [ActivityClass]){
        let _ = activities.reduce(self) { current, next in
            current.next = next
            return next
        }
    }
    
    @MainActor
    func start(
        context: ModelContext,
        parentObject: ActivityObject,
        priorityIndex: Int? = nil,
        stepNumber: Int
    ){
        parentObject.createSubActivity(
            context: context,
            activityClass: self,
            priorityIndex: priorityIndex,
            stepNumber: stepNumber
        )
    }
}

extension ActivityClass {
    static func dummyActivity() -> ActivityClass {
        return ActivityClass(
            name: "DummyClass",
            detail: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat"
        )
    }
    
    static func error() -> ActivityClass {
        return ActivityClass(name: "error")
    }
}

extension ActivityClass {
    @MainActor
    struct UIEditsManager : Observable {
        @Query var actClass: [ActivityClass]
        
        var name: String
        var detail: String
        var waitAfterStart: TimeInterval
        var subClasses: [ActivityClass]
        var next: ActivityClass?
        
        init(for activityClass: ActivityClass){
            let id = activityClass.id
            _actClass = Query(filter: #Predicate<ActivityClass>{$0.id == id})
            
            name = activityClass.name
            detail = activityClass.detail ?? ""
            waitAfterStart = activityClass.waitAfterCompletion ?? 0
            subClasses = activityClass.subActivities
            next = activityClass.next
        }
    }
}
