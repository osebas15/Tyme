//
//  ActiveScreen.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 7/10/24.
//

import SwiftUI

struct ActiveScreen: View {
    var activity: Activity
    var body: some View {
        VStack{
            Text(activity.name!)
            Spacer()
            Text(activity.detail!)
            Button("done"){
                print("done")
            }
        }
    }
}

#Preview {
    ActiveScreen(activity: Activity.getDummyActivities()[0])
}
