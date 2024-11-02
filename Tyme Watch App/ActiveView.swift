//
//  ActiveScreen.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 7/10/24.
//

import SwiftUI
import SwiftData

struct ActiveView: View {
    @Environment(\.modelContext) var context: ModelContext
    var activities: [ActivityObject]
    
    var body: some View {
        if activities.count == 1 && activities[0].unOrderedActivities.count > 0 {
            ActiveView(activities: activities[0].orderedActivities)
        }
        else {
            List(activities){ activity in
                ActiveObjectCellView(activity: activity)
            }
        }
    }
}
/*
#Preview {
    ActiveView(activity: ActivityClass.getDummyActivities()[0])
}
*/
