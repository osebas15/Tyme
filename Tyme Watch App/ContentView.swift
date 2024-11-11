//
//  ContentView.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 7/7/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query(filter: ModelHelper().homeObjectPredicate) var homeObject: [ActivityObject]
    @Query(filter: ModelHelper().homeActivityPredicate) var mainActivity: [ActivityClass]
    
    var body: some View {
        if homeObject.count > 0 && mainActivity.count > 0 {
            if homeObject[0].unOrderedActivities.count > 0 {
                ActiveView(activities: homeObject[0].lowestActivities)
            }
            else {
                HomeView(activities: mainActivity[0].orderedSubActivities, mainObject: homeObject[0])
            }
            
        }
        else {
            Text("Error loading HomeView")
        }
    }
}

#Preview {
    ContentView()
}
