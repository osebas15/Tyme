//
//  Activity.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 7/7/24.
//

import Foundation
import SwiftData

typealias Activity = Activity0_0_0.Activity

enum Activity0_0_0: VersionedSchema {
    static var models: [any PersistentModel.Type] = [Activity.self]
    
    static var versionIdentifier: Schema.Version = Schema.Version(0,0,0)
    
    @Model
    class Activity: Identifiable{
        
        let id = UUID()
        
        @Relationship(deleteRule: .noAction, inverse: \Activity.previous)
        var next: Activity?
        var previous: Activity?
        
        @Relationship(deleteRule: .cascade, inverse: \Activity.parent)
        var subActivities: [Activity]
        var parent: Activity?
        
        var name: String?
        var detail: String?
        
        var creationDate: Date?
        var completionDate: Date?
        var timeToComplete: TimeInterval?
        
        var onOffTimes: [TimeRange]?
        
        init(
            next: Activity? = nil,
            subActivities: [Activity] = [],
            timeToComplete: TimeInterval? = nil,
            name: String? = nil,
            detail: String? = nil,
            creationDate: Date? = nil,
            completionDate: Date? = nil,
            onOffTimes: [TimeRange]? = []
        ){
            self.name = name
            self.detail = detail
            self.next = next
            self.subActivities = subActivities
            self.creationDate = Date()
            self.timeToComplete = timeToComplete
            self.completionDate = completionDate
            self.onOffTimes = onOffTimes
        }
    }
}
