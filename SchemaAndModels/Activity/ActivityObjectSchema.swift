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
        
        init(
            activityClass: ActivityClass,
            completionDate: Date? = nil,
            onOffTimes: [TimeRange]? = nil,
            subActivities: [ActivityObject] = [],
            focus: FocusState = .none
        ) {
            self.activityClass = activityClass
            self.completionDate = completionDate
            self.onOffTimes = onOffTimes
            self.subActivities = subActivities
            self.storedFocus = focus.rawValue
        }
    }
}

extension ActivityObject {
    enum FocusState: Int { case main, passive, secondary, done, none, error }
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
