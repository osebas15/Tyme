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
    let sharedModelContainer: ModelContainer = ModelHelper.shared.getTestContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
