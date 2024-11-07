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
    
    var sortingAlgorithm: (ActivityObject, ActivityObject) -> Bool = { up, down in
        if up.currentStep != down.currentStep {
            return up.currentStep > down.currentStep
        }
        else if up.focus != down.focus {
            return up.focus.rawValue < down.focus.rawValue
        }
        else { return true }
    }
    
    init(activities: [ActivityObject]){
        self.activities = activities
    }
    
    var body: some View {
        List(activities){ activity in
            ActiveObjectCellView(currentTime: currentTime, activity: activity)
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
