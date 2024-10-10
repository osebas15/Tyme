//
//  ActivityView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 8/24/24.
//
// 

import SwiftUI
import SwiftData

struct ActivityView: View {
    @Query(filter: #Predicate<ActivityClass>{ act in
        true//act.parent == nil
    }) var activityClasses: [ActivityClass]
    
    var body: some View {
        List(activityClasses){activity in
            ActivityClassFullCellView(activity: activity)
        }
    }
}
/*
#Preview {
    ActivityView()
}
*/
