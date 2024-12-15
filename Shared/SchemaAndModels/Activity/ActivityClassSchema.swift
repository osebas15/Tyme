//
//  Activity.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 7/7/24.
//

import Foundation
import SwiftUI
@preconcurrency import SwiftData

typealias ActivityClass = ActivityClass0_0_0.ActivityClass

enum ActivityClass0_0_0: VersionedSchema {
    static let models: [any PersistentModel.Type] = [ActivityClass.self]
    
    static let versionIdentifier: Schema.Version = Schema.Version(0,0,0)
    
    @Model
    class ActivityClass: Identifiable{
        
        @Attribute(.unique) var id: UUID
        //var next: ActivityClass?
        
        private var steps: [ActivityClass]
        private var stepsOrder: [Int: UUID]
        @Transient var orderedSteps: [ActivityClass] {
            get {
                var toReturn = [ActivityClass]()
                for index in 0..<steps.count {
                    let actClass = steps.first { $0.id == stepsOrder[index] }!
                    toReturn.append(actClass)
                }
                return toReturn
            }
        }
        
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
        @Transient var unOrderedSubActivities: [ActivityClass] {
            get { return subActivities }
        }
        
        var name: String
        var detail: String?
        var timeToComplete: TimeInterval?
        var waitAfterCompletion: TimeInterval?
        
        var storedPriority: Int
        @Transient var priority: Priority {
            get { return Priority(rawValue: storedPriority) ?? .null }
            set { storedPriority = newValue.rawValue }
        }
        
        init(
            name: String?,
            timeToComplete: TimeInterval? = nil,
            waitAfterCompletion: TimeInterval? = nil,
            detail: String? = nil,
            priority: Priority = .null,
            id: UUID? = nil
        ){
            self.name = name ?? ""
            self.detail = detail
            self.subActivities = []
            self.subActivityOrder = [:]
            self.steps = []
            self.stepsOrder = [:]
            self.waitAfterCompletion = waitAfterCompletion
            self.timeToComplete = timeToComplete
            self.storedPriority = priority.rawValue
            self.id = id ?? UUID()
        }
    }
}

extension ActivityClass {
    enum Priority: Int { case immidiate, high, medium, low, passive, null }
    
    func stepAfter(origClass: ActivityClass) -> ActivityClass?{
        if origClass == self {
            return orderedSteps.first
        }
        guard
            let index = orderedSteps.firstIndex(where: { $0 == origClass }),
            self.steps.count > index + 1
        else {
            return nil
        }
        
        return orderedSteps[index + 1]
    }
}

extension ActivityClass {
    func addSubActivity(activity: ActivityClass){
        self.subActivityOrder[self.subActivityOrder.count] = activity.id
        self.subActivities.append(activity)
    }
    
    func addSteps(activities: [ActivityClass]){
        self.steps = activities
        
        activities.enumerated().forEach({ self.stepsOrder[$0.offset] = $0.element.id })
    }
    
    @MainActor
    func start(
        context: ModelContext,
        parentObject: ActivityObject,
        priorityIndex: Int? = nil
    ){
        parentObject.createSubActivity(
            context: context,
            activityClass: self,
            priorityIndex: priorityIndex
        )
    }
}

extension ActivityClass {
    static func dummyActivity() -> ActivityClass {
        let toReturn = ActivityClass(
            name: "DummyClass",
            detail: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat",
            id: UUID(uuidString: "396f24d5-096c-4edd-a2d8-e7fc46d70011")!
        )
        
        toReturn.addSubActivity(activity: ActivityClass(name: "sub1", id: UUID(uuidString: "45d1d273-6c4d-47a0-90fe-f7de8165088c")!))
        
        return toReturn
    }
    
    static func sampleActivitySteps() -> [ActivityClass] {
        let toReturn = [
            ActivityClass(name: "step 1", id: UUID(uuidString: "b9f99643-77db-4e9c-94f4-474300b5787f")),
            ActivityClass(name: "step 2", id: UUID(uuidString: "2d7bcba8-228d-46ce-9858-4acc5f2269b3")),
            ActivityClass(name: "step 3", id: UUID(uuidString: "31d441b6-c262-4976-b961-0f6b1c2c49dd"))
        ]
        
        return toReturn
    }
    
    static func error() -> ActivityClass {
        return ActivityClass(name: "error", id: UUID(uuidString: "8c39f05e-c0db-48b1-a112-44d088c1cef4"))
    }
}


extension ActivityClass {
    @MainActor
    struct UIEditsManager : Observable {
        var id: UUID
        var name: String
        var detail: String
        var waitAfterStart: TimeInterval
        var subClasses: [ActivityClass]
        var isEditing = false
        
        init(for activityClass: ActivityClass){
            id = activityClass.id
            name = activityClass.name
            detail = activityClass.detail ?? ""
            waitAfterStart = activityClass.waitAfterCompletion ?? 0
            subClasses = activityClass.subActivities
        }
        
        func save(container: ModelContainer){
            var editableActClassFd = FetchDescriptor(predicate: #Predicate<ActivityClass>{$0.id == id})
            
            editableActClassFd.fetchLimit = 1
            let editableActClass = try? container.mainContext.fetch(editableActClassFd)
            
            guard let toSave = editableActClass?.first else { return }
            
            toSave.name = name
            toSave.detail = detail
            toSave.waitAfterCompletion = waitAfterStart
            //toSave.subclasses
            
            try? container.mainContext.save()
        }
    }
}
