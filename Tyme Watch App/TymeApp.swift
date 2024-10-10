//
//  TymeApp.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 7/7/24.
//

import SwiftUI
import SwiftData

@main
struct Tyme_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(ModelHelper.shared.getTestContainer())
    }
}
