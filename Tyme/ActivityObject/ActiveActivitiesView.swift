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
                ForEach(activity.subActivities){ subActivity in
                    ActivityObjectCellView(activityObject: subActivity)
                }
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
