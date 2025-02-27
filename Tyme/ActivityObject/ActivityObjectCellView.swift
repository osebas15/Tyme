//
//  ActivityObjectSmallCellView.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 10/11/24.
//

import SwiftUI

struct ActivityObjectCellView: View {
    @Environment(\.modelContext) var context
    //@Environment(\.timerManager) var timerManager
    let activityObject: ActivityObject
    let currentTime: Date
    
    var body: some View {
        HStack {
            //ActObjStatusCircleView(obj: activityObject)
            VStack{
                Text(activityObject.activityClass?.name ?? "activityclass error")
                HStack{
                    Button(activityObject.hasNext ? "next" : "done"){
                        //activityObject.checkAndContinueState(context: context, timerManager: timerManager)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    ActivityObjectWaitCountDown(
                        currentTime: currentTime, actObject: activityObject)
                    Spacer()
                }
            }
            .frame(alignment: .leading)
        }
    }
}

#Preview {
    //we want to test
    //  with wait time
    //      .waitingToStart
    //      .started
    //      .inSubsteps
    //      .done
    //      .overdue
    //      .error
    //  without wait time
    //      just have a checkmark
    
    let sample = ActivityObject.dummyObject()
    ActivityObjectCellView(activityObject: sample, currentTime: Date())
}
