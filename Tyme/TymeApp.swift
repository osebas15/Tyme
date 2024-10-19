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
    let modelContainer: ModelContainer = ModelHelper().getTestContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
