//
//  ActiveActivitiesView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 10/9/24.
//

import SwiftUI

struct ActiveActivitiesView: View {
    var activeActivities: [ActivityObject]
    var body: some View {
        List(activeActivities){ activity in
            DisclosureGroup{
                //if one sub activity then start it automatically, if multiple then show them all in an inactive state
                //ActiveObje
                //ActiveObjectSubActivitiesView(activities: activity.subActivities)
                Text("objects go here")
            } label: {
                ActivityObjectCellView(activityObject: activity)
            }
        }
    }
}
/*
#Preview {
    ActiveActivitiesView()
}
*/
