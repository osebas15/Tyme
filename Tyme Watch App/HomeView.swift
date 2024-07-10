//
//  HomeView.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 7/10/24.
//

import SwiftUI

struct HomeView: View {
    //Query with swiftdata use
    var activities: [Activity] = Activity.getDummyActivities()
    var body: some View {
        VStack{
            Text("Start")
            NavigationStack{
                List{
                    ForEach(activities){ activity in
                        NavigationLink(destination: ActiveScreen(activity: activity)) {
                            Text(activity.name!)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
