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
        
        @Attribute(.unique) var id = UUID()
        
        @Relationship(deleteRule: .noAction, inverse: \ActivityClass.previous)
        var next: ActivityClass?
        var previous: ActivityClass?
        
        var subActivities: [ActivityClass]
        
        @Relationship(deleteRule: .cascade, inverse: \ActivityObject.activityClass) var objects: [ActivityObject] = []
        
        var name: String
        var detail: String?

        var timeToComplete: TimeInterval?
        
        init(
            name: String,
            next: ActivityClass? = nil,
            subActivities: [ActivityClass] = [],
            parents: [ActivityClass] = [],
            timeToComplete: TimeInterval? = nil,
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


extension ActivityClass {
    func start(context: ModelContext, appState: AppState){
        //create object
        let newObject = ActivityObject(activityClass: self)
        //insert and save
        Task{ @MainActor in
            context.insert(newObject)
            appState.activeActivities.append(newObject)
            try? context.save()
        }
    }
}
