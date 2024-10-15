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
    @Query(filter: ModelHelper.shared.mainActivitiesPredicate ) var mainActivities: [ActivityClass]
    
    var body: some View {
        if mainActivities.count > 0 && homeObject.count > 0 {
            VStack{
                List(mainActivities){ activity in
                    DisclosureGroup{
                        ForEach(activity.subActivities){
                            Text($0.name)
                        }
                    } label: {
                        ActivityClassSmallCellView(activityClass: activity, parentObject: homeObject[0])
                    }
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
            Text("Couldn't load home \(mainActivities.count) \(homeObject.count)")
        }
    }
}
/*
#Preview {
    NewActivityListView()
}
*/
