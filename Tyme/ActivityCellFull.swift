//
//  ActivityCellFull.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 9/14/24.
//

import SwiftUI

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

#Preview {
    ActivityCellFull()
}
