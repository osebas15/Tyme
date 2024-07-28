//
//  Activity.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 7/7/24.
//

import Foundation
import SwiftData

typealias ActivityClass = ActivityClass0_0_0.ActivityClass

enum ActivityClass0_0_0: VersionedSchema {
    static var models: [any PersistentModel.Type] = [ActivityClass.self]
    
    static var versionIdentifier: Schema.Version = Schema.Version(0,0,0)
    
    @Model
    class ActivityClass: Identifiable{
        
        @Attribute(.unique) let id = UUID()
        
        @Relationship(deleteRule: .noAction, inverse: \ActivityClass.previous)
        var next: ActivityClass?
        var previous: ActivityClass?
        
        @Relationship(deleteRule: .cascade, inverse: \ActivityClass.parent)
        var subActivities: [ActivityClass]
        var parent: ActivityClass?
        
        //var objects: [Activi]
        
        var name: String?
        var detail: String?

        var timeToComplete: TimeInterval?
        
        init(
            next: ActivityClass? = nil,
            subActivities: [ActivityClass] = [],
            timeToComplete: TimeInterval? = nil,
            name: String? = nil,
            detail: String? = nil
        ){
            self.name = name
            self.detail = detail
            self.next = next
            self.subActivities = subActivities
            self.timeToComplete = timeToComplete
        }
    }
}
