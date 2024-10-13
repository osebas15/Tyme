//
//  ActivityObjectDetailView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 10/11/24.
//

import SwiftUI

struct ActivityObjectDetailView: View {
    var activityObject: ActivityObject
    var body: some View {
        VStack{
            if let detail = activityObject.activityClass?.detail {
                Text(detail)
            }
            Text("steps")
            /*List(activityObject.activityClass.subActivities){
            }*/
        }
    }
}
/*
#Preview {
    ActivityObjectDetailView()
}
*/
