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
        
        @Transient var creationDate : Date? {
            get {
                return onOffTimes?.first?.start
            }
        }
        var completionDate: Date?
        var onOffTimes: [TimeRange]?
        
        init(completionDate: Date? = nil, onOffTimes: [TimeRange]? = nil) {
            self.completionDate = completionDate
            self.onOffTimes = onOffTimes
        }
    }
}
