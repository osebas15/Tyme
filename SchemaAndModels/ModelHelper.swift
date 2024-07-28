//
//  ModelHelper.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 7/10/24.
//

import Foundation
import SwiftData

struct ModelHelper {
    nonisolated static func getBasicContainer() -> ModelContainer {
        let schema = Schema([
            ActivityClass.self
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
        
        return modelContainer
    }
    
    nonisolated static func getTestContainer() -> ModelContainer {
        let basicContainer = getBasicContainer()
        
        let _ = ActivityClass.getSwissBurgerRecepie(insertIntoContainer: basicContainer)
        
        return basicContainer
    }
}
