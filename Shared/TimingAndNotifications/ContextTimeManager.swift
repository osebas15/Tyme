//
//  ContextTimeManager.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 12/25/24.
//

import Foundation
import SwiftData

@MainActor
struct ContextTimeManager{
    func currentState(context: ModelContext) -> ContextState{
        let activeObjs = getActiveActivities(context: context)
        
        if activeObjs.isEmpty {
            return .stable
        }
        else {
            let states = Set<ActivityObject.FocusState>(activeObjs.map({ obj in
                let thisState = obj.verifyCurrentState()
                return thisState == .inSubsteps ? obj.currentStep.verifyCurrentState() : thisState
            }))
            
            if states.contains(.error){
                return .error
            }
            else if states.contains(.started){
                return .waitingForTimedEvent
            }
            else if states.contains(.waitingToStart){
                return .waitingForUserInput
            }
        }
        return .stable
    }
    
    func getActiveActivities(context: ModelContext) -> [ActivityObject]{
        let home = ModelHelper().getHomeObject(container: context.container)
        return home.orderedActivities
    }
}

extension ContextTimeManager{
    enum ContextState {
        case stable, //no active tasks, no pending user actions
            waitingForUserInput, //active tasks but nothing will happen without user input
            waitingForTimedEvent, //active tasks that will update at some preset point in the future
            needsStateReduction,
            error
    }
}
