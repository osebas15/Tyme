//
//  ModelHelper.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 7/10/24.
//

import Foundation
import SwiftData

@MainActor
struct ModelHelper {

    let homeActivityPredicate = #Predicate<ActivityClass> { activity in
        activity.name == "Home"
    }
    
    let homeObjectPredicate = #Predicate<ActivityObject>{ activity in
        return (activity.activityClass?.name == "Home") == true
    }
    
    func ifMissingCreateHomeObject(container: ModelContainer) {
        //check for activityClass and add if missing
        var fd = FetchDescriptor(predicate: homeObjectPredicate)
        fd.fetchLimit = 1
        let result = try? container.mainContext.fetch(fd)
        
        if (result?.isEmpty ?? false){
            var homeClassFd = FetchDescriptor(predicate: homeActivityPredicate)
            homeClassFd.fetchLimit = 1
            let hcResult = try? container.mainContext.fetch(homeClassFd)
            
            var homeClass: ActivityClass?
            
            if (hcResult?.isEmpty ?? false){
                homeClass = ActivityClass(name: "Home")
            }
            else {
                homeClass = hcResult![0]
            }
            
            let homeObject = ActivityObject(activityClass: homeClass!, priorityOrder: 0)
            container.mainContext.insert(homeObject)
        }
    }
    
    func getBasicContainer() -> ModelContainer {
        let schema = Schema([
            ActivityClass.self,
            ActivityObject.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        var modelContainer: ModelContainer?
        do {
            modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )

        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        guard let modelContainer = modelContainer else {
            fatalError("Could not create ModelContainer")
        }
        
        ifMissingCreateHomeObject(container: modelContainer)
        
        return modelContainer
    }
    
    func getTestContainer() -> ModelContainer {
        let basicContainer = getBasicContainer()
        
        ActivityDummyData().insertHipExercises(into: basicContainer)
        ActivityDummyData().insertQuickBreakfastRecepie(into: basicContainer)
        
        return basicContainer
    }
    
    func getHomeObject(container: ModelContainer) -> ActivityObject {
        var fd = FetchDescriptor(predicate: homeObjectPredicate)
        fd.fetchLimit = 1
        let result = try? container.mainContext.fetch(fd)
        
        if let result = result, result.count == 1 {
            return result[0]
        }
        else {
            return ActivityObject.error()
        }
    }
    
    func getHomeActClass(container: ModelContainer) -> ActivityClass {
        var fd = FetchDescriptor(predicate: homeActivityPredicate)
        fd.fetchLimit = 1
        let result = try? container.mainContext.fetch(fd)
        
        if let result = result, result.count == 1 {
            return result[0]
        }
        else {
            return ActivityClass.error()
        }
    }
}

@MainActor
extension ModelHelper {
    func queriedCopy(container: ModelContainer, id: PersistentIdentifier) -> ActivityObject {
        var fd = FetchDescriptor<ActivityObject>(predicate: #Predicate{ obj in
            return obj.persistentModelID == id
        })
        fd.fetchLimit = 1
        
        var toReturn = ActivityObject.error()
        
        if let result = try? container.mainContext.fetch(fd), result.count == 1{
            toReturn = result[0]
        }
        
        return toReturn
    }
    
    func isActive(context: ModelContext) -> Bool{
        let home = getHomeObject(container: context.container)
        
        return home.numberOfSubActivities > 0
    }
}
