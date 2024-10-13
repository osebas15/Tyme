//
//  ActivityObject.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 7/27/24.
//

import Foundation
import SwiftData
import SwiftUI

typealias ActivityObject = ActivityObject0_0_0.ActivityObject

enum ActivityObject0_0_0: VersionedSchema {
    static var models: [any PersistentModel.Type] = [ActivityObject.self]
    
    static var versionIdentifier = Schema.Version(0, 0, 0)
    
    @Model
    class ActivityObject: Identifiable {
        
        @Attribute(.unique) var id = UUID()
        
        @Relationship(
            deleteRule: .nullify,
            inverse: \ActivityObject.parent
        ) var activeSubActivities: [ActivityObject]
        var parent: ActivityObject?
        
        var activityClass : ActivityClass
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
            activeSubActivities: [ActivityObject] = []
        ) {
            self.activityClass = activityClass
            self.completionDate = completionDate
            self.onOffTimes = onOffTimes
            self.activeSubActivities = activeSubActivities
        }
    }
}

extension ActivityObject {
    static var error = ActivityObject(activityClass: ActivityClass.error)
}

extension ActivityObject {
    func removeSubActivity(context: ModelContext, activity: ActivityObject){
        if let position = activeSubActivities.firstIndex(where: { $0.id == activity.id }){
            activeSubActivities.remove(at: position)
            context.delete(activity)
        }
    }
    
    func done(context: ModelContext){
        if let parent = parent{
            parent.removeSubActivity(context: context, activity: self)
        }
    }
}

private struct HomeObjectKey: EnvironmentKey {
    static let defaultValue = ActivityObject(activityClass: ActivityClass.error)
}

extension EnvironmentValues{
    var homeObject: ActivityObject{
        get{
            self[HomeObjectKey.self]
        }
        set{
            self[HomeObjectKey.self] = newValue
        }
    }
}
