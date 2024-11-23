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
    ContentView()
        .modelContainer(ModelHelper().getBasicContainer())
}
