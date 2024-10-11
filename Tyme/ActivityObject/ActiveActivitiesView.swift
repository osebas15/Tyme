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
        List(activeActivities){
            ActivityObjectSmallCellView(activityObject: $0)
        }
    }
}
/*
#Preview {
    ActiveActivitiesView()
}
*/
