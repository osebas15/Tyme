//
//  ActiveObjectCellView.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 10/31/24.
//

import SwiftUI
import SwiftData

struct ActiveObjectCellView: View {
    @Environment(\.modelContext) var context: ModelContext
    @Environment(\.timerManager) var timerManager: TimerManager
    
    @Query var activity: [ActivityObject]
    
    var currentTime: Date
    
    init(activity: ActivityObject, currentTime: Date) {
        let activityId = activity.id
        _activity = Query(filter: #Predicate<ActivityObject>{ $0.id == activityId })
        self.currentTime = currentTime
    }
    
    var body: some View {
        VStack{
            if let activity = activity.first {
                HStack{
                    if activity.focus == .done {
                        Image(systemName: "circle.fill")
                            .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.2))
                    }
                    else if activity.focus == .passive {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.yellow)
                    }
                    else {
                        Image(systemName: "circle")
                            .foregroundColor(.gray)
                    }
                    Text(activity.activityClass?.name ?? "ERROR")
                }
                
                if let waitUntil = activity.waitUntilDate, activity.focus == .passive{
                    let time = waitUntil.timeIntervalSince(currentTime)
                    Text(time.description)
                }
            }
            else {
                Text("no object here")
            }
        }
        .onTapGesture {
            if let activity = activity.first {
                activity.checkAndContinueState(context: context, timerManager: timerManager)
            }
        }
    }
}
/*
#Preview {
    ActiveObjectCellView(activity: ActivityObject.dummyObject())
}

*/
