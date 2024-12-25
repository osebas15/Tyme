//
//  ActObjStartWaitButton.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/15/24.
//

import SwiftUI
import SwiftData

struct ActObjStartWaitButton: View {
    @Environment(\.modelContext) var context: ModelContext
    @Environment(\.timerManager) var timerManager: TimerManager
    
    @Query var actObj : [ActivityObject]
    
    init(actObj: ActivityObject) {
        let id = actObj.persistentModelID
        _actObj = Query(filter: #Predicate<ActivityObject>{
            $0.persistentModelID == id
        })
    }
    
    var body: some View {
        Button("done"){
           // checkAndCountinueAction(actObj[0], context, timerManager)
        }
        .buttonStyle(BorderedButtonStyle())
    }
}
/*
extension ActObjStartWaitButton{
    var checkAndCountinueAction: ((ActivityObject, ModelContext, TimerManager) ->()) {
        { $0.checkAndContinueState(context: $1, timerManager: $2) }
    }
}
*/
/*
#Preview {
    ActObjStartWaitButton()
}*/
