//
//  TymeApp.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 7/7/24.
//

import SwiftUI
import SwiftData

@main
struct TymeApp: App {
    var sharedModelContainer: ModelContainer = ModelHelper.getTestContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
