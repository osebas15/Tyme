//
//  TimerManager.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/2/24.
//

import Foundation
import SwiftData

class TimerManager {
    var currentTimers = [UUID: Timer]()
    
    func startTimer(context: ModelContext, forObject: ActivityObject){
        let newTimer = Timer(timeInterval: forObject.waitAfterCompletion, repeats: false){ timer in
            forObject.checkAndContinueState(context: context)
            endTimer(id: forObject.id)
        }
        currentTimers[forObject.id] = newTimer
    }
    
    func endTimer(id: UUID){
        currentTimers[id].invalidate()
        currentTimers.removeValue(forKey: id)
    }
}
