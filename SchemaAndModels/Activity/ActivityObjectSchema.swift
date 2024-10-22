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
        
        @Transient var creationDate : Date? {
            get {
                return onOffTimes?.first?.start
            }
        }
        
        init(
            activityClass: ActivityClass,
            completionDate: Date? = nil,
            onOffTimes: [TimeRange]? = nil,
            subActivities: [ActivityObject] = []
        ) {
            self.activityClass = activityClass
            self.completionDate = completionDate
            self.onOffTimes = onOffTimes
            self.subActivities = subActivities
        }
    }
}

extension ActivityObject {
    @MainActor static let error = ActivityObject(activityClass: ActivityClass.error)
}

extension ActivityObject {
    func removeSubActivity(context: ModelContext, activity: ActivityObject){
        if let position = subActivities.firstIndex(where: { $0.id == activity.id }){
            subActivities.remove(at: position)
            context.delete(activity)
        }
    }
    
    func done(context: ModelContext){
        if let parent = parent{
            parent.removeSubActivity(context: context, activity: self)
        }
    }
}
