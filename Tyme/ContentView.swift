//
//  ContentView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 7/7/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(filter: ModelHelper.shared.appStatePredicate) var appState: [AppState]
    
    var body: some View {
        NavigationStack{
            VStack {
                if appState.count > 0 {
                    if appState[0].activeActivities.isEmpty{
                        NewActivityListView()
                    }
                    else {
                        ActiveActivitiesView(activeActivities: appState[0].activeActivities)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
