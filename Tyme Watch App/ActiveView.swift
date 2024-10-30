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
        if activities.count == 1 && activities[0].subActivities.count > 0 {
            ActiveView(activities: activities[0].subActivities)
        }
        else {
            List(activities){ activity in
                Text(activity.activityClass!.name)
                    .onTapGesture {
                        activity.done(context: context)
                    }
            }
        }
    }
}
/*
#Preview {
    ActiveView(activity: ActivityClass.getDummyActivities()[0])
}
*/
