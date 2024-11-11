//
//  ActiveScreen.swift
//  Tyme Watch App
//
//  Created by Sebastian Aguirre on 7/10/24.
//

import SwiftUI
import SwiftData

struct ActiveView: View {
    @Environment(\.modelContext) var context: ModelContext
    @State var currentTime: Date = Date()
    var activities: [ActivityObject]
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(activities: [ActivityObject]){
        self.activities = activities
            .enumerated().sorted(by: { up, down in
                if up.element.focus != down.element.focus {
                    return up.element.focus.rawValue < down.element.focus.rawValue
                }
                else {
                    return up.offset < down.offset
                }
            })
            .map{$0.1}
    }
    
    var body: some View {
        List(activities){ activity in
            ActiveObjectCellView(activity: activity, currentTime: currentTime)
        }
        .onReceive(timer) { _ in
            self.currentTime = Date()
        }
    }
}
/*
#Preview {
    ActiveView(activity: ActivityClass.getDummyActivities()[0])
}
*/
