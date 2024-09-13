//
//  ActivityObject.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 7/27/24.
//

import Foundation
import SwiftData

typealias ActivityObject = ActivityObject0_0_0.ActivityObject

enum ActivityObject0_0_0: VersionedSchema {
    static var models: [any PersistentModel.Type] = [ActivityObject.self]
    
    static var versionIdentifier = Schema.Version(0, 0, 0)
    
    @Model
    class ActivityObject: Identifiable {
        
        @Attribute(.unique) let id = UUID()
        
        @Transient var creationDate : Date? {
            get {
                return onOffTimes?.first?.start
            }
        }
        
        var completionDate: Date?
        var onOffTimes: [TimeRange]?
        @Relationship var activityClass : ActivityClass
        
        
        init(completionDate: Date? = nil, onOffTimes: [TimeRange]? = nil, activityClass: ActivityClass) {
            self.completionDate = completionDate
            self.onOffTimes = onOffTimes
            self.activityClass = activityClass
        }
    }
}
