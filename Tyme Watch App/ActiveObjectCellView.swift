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
    
    var currentTime: Date
    
    let activity: ActivityObject
    
    var body: some View {
        VStack{
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
               
                Text(activity.activityClass!.name)
            }
            
            if let waitUntil = activity.waitUntilDate, activity.focus == .passive{
                let time = waitUntil.timeIntervalSince(currentTime)
                Text(time.description)
            }
            
            
        }
        .onTapGesture {
            activity.checkAndContinueState(context: context, timerManager: timerManager)
        }
    }
}
/*
#Preview {
    ActiveObjectCellView(activity: ActivityObject.dummyObject())
}

*/
