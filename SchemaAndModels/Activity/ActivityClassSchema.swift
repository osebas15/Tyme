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
        
        var subActivities: [ActivityClass]
        var canDoSubActivitiesInParallel: Bool
        var createdFrom: ActivityClass?
        var name: String
        var detail: String?
        var timeToComplete: TimeInterval?
        
        init(
            name: String,
            next: ActivityClass? = nil,
            subActivities: [ActivityClass] = [],
            canDoSubActivitiesInParallel: Bool = false,
            timeToComplete: TimeInterval? = nil,
            detail: String? = nil,
            createdFrom: ActivityClass? = nil
        ){
            self.name = name
            self.detail = detail
            self.next = next
            self.subActivities = subActivities
            self.canDoSubActivitiesInParallel = canDoSubActivitiesInParallel
            self.timeToComplete = timeToComplete
            self.createdFrom = createdFrom
        }
    }
}

extension ActivityClass {
    @MainActor static let error = ActivityClass(name: "error")
}

extension ActivityClass {
    func start(context: ModelContext, parentObject: ActivityObject){
        let newObject = ActivityObject(activityClass: self)
        context.insert(newObject)
        parentObject.subActivities.append(newObject)
        
        if self.subActivities.count > 0 {
            if self.canDoSubActivitiesInParallel {
                self.subActivities.forEach { $0.start(context: context, parentObject: newObject) }
            }
            else {
                self.subActivities[0].start(context: context, parentObject: newObject)
            }
        }
    }
}
