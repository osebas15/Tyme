//
//  ActiveScreen.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 7/10/24.
//

import SwiftUI

struct ActiveView: View {
    var activity: ActivityObject
    var body: some View {
        VStack{
            Text(activity.activityClass.name)
            Spacer()
            if let detail = activity.activityClass.detail{
                Text(detail)
            }
            
            Button("done"){
                print("done")
            }
        }
    }
}
/*
#Preview {
    ActiveView(activity: ActivityClass.getDummyActivities()[0])
}
*/
