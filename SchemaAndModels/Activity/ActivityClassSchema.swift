//
//  Activity.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 7/7/24.
//

import Foundation
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
        
        var canDoSubActivitiesInParallel: Bool
        
        var name: String
        var detail: String?
        var timeToComplete: TimeInterval?
        
        init(
            name: String,
            next: ActivityClass? = nil,
            canDoSubActivitiesInParallel: Bool = false,
            timeToComplete: TimeInterval? = nil,
            detail: String? = nil
        ){
            self.name = name
            self.detail = detail
            self.next = next
            self.subActivities = []
            self.subActivityOrder = [:]
            self.canDoSubActivitiesInParallel = canDoSubActivitiesInParallel
            self.timeToComplete = timeToComplete
        }
    }
}

extension ActivityClass {
    @MainActor static let error = ActivityClass(name: "error")
}

extension ActivityClass {
    func addSubActivity(activity: ActivityClass){
        self.subActivities.append(activity)
        self.subActivityOrder[self.subActivityOrder.count] = activity.id
    }
    
    func start(context: ModelContext, parentObject: ActivityObject){
        let newObject = ActivityObject(activityClass: self)
        context.insert(newObject)
        parentObject.subActivities.append(newObject)
        
        if self.subActivities.count > 0 {
            if self.canDoSubActivitiesInParallel {
                self.subActivities.forEach { $0.start(context: context, parentObject: newObject) }
            }
            else {
                let firstActivityId = self.subActivityOrder[0]
                self.subActivities
                    .first(where: {$0.id == firstActivityId})!
                    .start(context: context, parentObject: newObject)
            }
        }
    }
}
