//
//  ActiveActivitiesView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 10/9/24.
//

import SwiftUI

struct ActiveActivitiesView: View {
    var activeActivities: [ActivityObject]
    @State var currentTime: Date = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        List(activeActivities){ activity in
            DisclosureGroup{
                ForEach(activity.orderedActivities){ subActivity in
                    ActivityObjectCellView(activityObject: subActivity, currentTime: currentTime)
                }
            } label: {
                ActivityObjectCellView(activityObject: activity, currentTime: currentTime)
            }
            .onReceive(timer) { _ in
                print("in received")
                currentTime = Date()
            }
        }
    }
}
/*
#Preview {
    ActiveActivitiesView()
}
*/
