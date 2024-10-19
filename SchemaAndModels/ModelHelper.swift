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
    let mainActivitiesPredicate = #Predicate<ActivityClass> { activity in
        if let creatingClass = activity.createdFrom {
            return creatingClass.name == "Home"
        }
        else {
            return false
        }
    }
    
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
                container.mainContext.insert(homeClass!)
                print("home class created and inserted")
            }
            else {
                homeClass = hcResult![0]
                print("home class found")
            }
            
            let homeObject = ActivityObject(activityClass: homeClass!)
            container.mainContext.insert(homeObject)
            try! container.mainContext.save()
            print("home object inserted")
        }
        else {
            print("home object found")
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
        
        //let _ = ActivityClass.getSwissBurgerRecepie(insertIntoContainer: basicContainer)
        
        return basicContainer
    }
}
