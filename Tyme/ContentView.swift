//
//  ContentView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 7/7/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        HomeNavigator()
    }
}

#Preview {
    let container: ModelContainer = {
        let toReturn = ModelHelper().getTestContainer()
        ActivityDummyData().insertQuickBreakfastRecepie(into: toReturn)
        return toReturn
    }()
    
    ContentView()
        .modelContainer(container)
}
