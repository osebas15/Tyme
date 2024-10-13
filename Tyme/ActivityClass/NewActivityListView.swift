//
//  NewActivityListView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 9/30/24.
//

import SwiftUI
import SwiftData

struct NewActivityListView: View {
    @Query(filter: ModelHelper.shared.homeActivityPredicate)
    var home: [ActivityClass]
    
    var body: some View {
        if home.count > 0 {
            VStack{
                List(home[0].subActivities){activity in
                    ActivityClassSmallCellView(activityClass: activity)
                }
            }
            .navigationTitle("Start Activity")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add"){
                        print("add pressed")
                    }
                }
            }
        }
        else {
            Text("Couldn't load home")
        }
    }
}
/*
#Preview {
    NewActivityListView()
}
*/
