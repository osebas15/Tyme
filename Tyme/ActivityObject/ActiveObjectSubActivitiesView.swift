//
//  ActiveObjectSubActivitiesView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 10/15/24.
//

import SwiftUI

struct ActiveObjectSubActivitiesView: View {
    let activities: [ActivityObject]
    var body: some View {
        ForEach(activities){
            Text($0.activityClass?.name ?? "error")
        }
    }
}
/*
#Preview {
    ActiveObjectSubActivitiesView()
}
*/
