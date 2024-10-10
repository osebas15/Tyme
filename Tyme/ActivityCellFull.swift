//
//  ActivityCellFull.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 9/14/24.
//

import SwiftUI
import SwiftData

struct ActivityCellFull: View {
    
    var activity: ActivityObject
    
    var totalTime: TimeInterval?{
        get {
            return activity.onOffTimes?
                .reduce(TimeInterval(0), {$0 + $1.totalTime()})
        }
    }
    
    var body: some View {
        VStack{
            Text(activity.activityClass.name ?? "name error")
            HStack{
                Text(totalTime?.description ?? "time error")
            }
        }
    }
}
/*
#Preview {
    let actClass = ActivityClass(name: "test")

    let activity = ActivityObject(activityClass: actClass)
    
    return ActivityCellFull(activity: activity)

}
*/
