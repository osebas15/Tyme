//
//  ActiveScreen.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 7/10/24.
//

import SwiftUI

struct ActiveView: View {
    var activity: ActivityClass
    var body: some View {
        VStack{
            Text(activity.name!)
            Spacer()
            if let detail = activity.detail{
                Text(detail)
            }
            
            Button("done"){
                print("done")
            }
        }
    }
}

#Preview {
    ActiveView(activity: ActivityClass.getDummyActivities()[0])
}
