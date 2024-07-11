//
//  PassiveView.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 7/10/24.
//

import SwiftUI

struct PassiveView: View {
    var activity: Activity
    var body: some View {
        VStack {
            Text("To Do")
           // NavigationStack{
                List{
                    ForEach(activity.subActivities){ activity in
                        //NavigationLink(destination: ActiveScreen(activity: activity)) {
                            Text(activity.name!)
                        //}
                    }
                }
            //}
        }
    }
}

#Preview {
    PassiveView(activity: Activity.getDummyActivities()[0])
}
