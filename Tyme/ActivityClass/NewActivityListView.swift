//
//  NewActivityListView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 9/30/24.
//

import SwiftUI
import SwiftData

struct NewActivityListView: View {
    @Query(filter: ModelHelper().homeObjectPredicate) var homeObject: [ActivityObject]
    @Query(filter: ModelHelper().homeActivityPredicate ) var mainClass: [ActivityClass]
    
    var body: some View {
        if mainClass.count > 0 && homeObject.count > 0 {
            VStack{
                List(mainClass[0].orderedSubActivities){ activity in
                    DisclosureGroup{
                        ForEach(activity.orderedSubActivities){
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
            Text("add new activities \(mainClass.count) \(homeObject.count)")
        }
    }
}
/*
#Preview {
    NewActivityListView()
}
*/
