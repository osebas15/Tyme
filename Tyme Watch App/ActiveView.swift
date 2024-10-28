//
//  ActiveScreen.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 7/10/24.
//

import SwiftUI

struct ActiveView: View {
    var activities: [ActivityObject]
    var body: some View {
        List(activities){ activity in
            Text(activity.activityClass!.name)
        }
    }
}
/*
#Preview {
    ActiveView(activity: ActivityClass.getDummyActivities()[0])
}
*/
