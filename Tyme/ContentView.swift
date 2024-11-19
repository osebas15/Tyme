//
//  ContentView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 7/7/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(filter: ModelHelper().homeObjectPredicate) var homeObjectResult: [ActivityObject]
    var body: some View {
        NavigationStack{
            VStack {
                if homeObjectResult.count > 0 {
                    if homeObjectResult[0].unOrderedActivities.isEmpty{
                        NewActivityListView()
                    }
                    else {
                        ActiveActivitiesView(activeActivities: homeObjectResult[0].lowestActivities)
                    }
                }
                else {
                    HStack{
                        Text("Home Object did not load \(homeObjectResult.count)")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
