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
    static func getBasicContainer() -> ModelContainer {
        let schema = Schema([
            Activity.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

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
        
        return modelContainer
    }
    
    
    
    static func getTestContainer() -> ModelContainer {
        var basicContainer = getBasicContainer()
        
        for activity in Activity.getDummyActivities(){
            Task{
                basicContainer.mainContext.insert(activity)
            }
        }
        
        return basicContainer
    }
}
