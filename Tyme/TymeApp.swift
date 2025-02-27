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
    let timerManager: TimerManager = TimerManager()
    let navStore: NavigationStore = NavigationStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
        .timerManager(timerManager)
        .navigationRedux(navStore)
    }
}
