//
//  NewActivityListView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 9/30/24.
//

import SwiftUI
import SwiftData

struct NewActivityListView: View {
    @Query(filter: ModelHelper.shared.homeObjectPredicate) var homeObject: [ActivityObject]
    @Query(filter: #Predicate<ActivityClass>{ $0.isMainActivity } ) var allActivities: [ActivityClass]
    
    var body: some View {
        if allActivities.count > 0 && homeObject.count > 0 {
            VStack{
                List(allActivities){ activity in
                    ActivityClassSmallCellView(activityClass: activity, parentObject: homeObject[0])
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
