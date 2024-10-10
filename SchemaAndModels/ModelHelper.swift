//
//  ModelHelper.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 7/10/24.
//

import Foundation
import SwiftData

struct ModelHelper {
    
    static let shared = ModelHelper()
    
    let homePredicate = #Predicate<ActivityClass>{ activity in
        activity.name == "Home"
    }
    
    let appStatePredicate = #Predicate<AppState>{_ in true}
    
    nonisolated func ifMissingCreateHomeActivity(container: ModelContainer){
        //check for activityClass and add if missing
        Task {@MainActor in
            var fd = FetchDescriptor(predicate: homePredicate)
            fd.fetchLimit = 1
            let result = try? container.mainContext.fetch(fd)
            
            if (result?.isEmpty ?? false){
                let home = ActivityClass(name: "Home")
                container.mainContext.insert(home)
            }
        }
    }
    
    nonisolated func ifMissingCreateAppState(container: ModelContainer){
        Task {@MainActor in
            var fd = FetchDescriptor(predicate: appStatePredicate)
            fd.fetchLimit = 1
            let result = try? container.mainContext.fetch(fd)
            
            if (result?.isEmpty ?? false){
                let appState = AppState()
                container.mainContext.insert(appState)
            }
        }
    }
    
    nonisolated func getBasicContainer() -> ModelContainer {
        let schema = Schema([
            ActivityClass.self,
            AppState.self
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
        
        ifMissingCreateHomeActivity(container: modelContainer)
        ifMissingCreateAppState(container: modelContainer)
        
        return modelContainer
    }
    
    nonisolated func getTestContainer() -> ModelContainer {
        let basicContainer = getBasicContainer()
        
        let _ = ActivityClass.getSwissBurgerRecepie(insertIntoContainer: basicContainer)
        
        return basicContainer
    }
}
