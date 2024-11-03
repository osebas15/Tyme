//
//  TimerManager.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/2/24.
//

import Foundation
import SwiftData
import SwiftUI

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
        currentTimers[id]?.invalidate()
        currentTimers.removeValue(forKey: id)
    }
}

private struct TimerManagerKey: EnvironmentKey {
    static let defaultValue = TimerManager()
}

extension EnvironmentValues {
    var timerManager: TimerManager {
        get { self[TimerManagerKey.self] }
        set { self[TimerManagerKey.self] = newValue }
    }
}

extension Scene {
    func timerManager(_ manager: TimerManager) -> some Scene {
        environment(\.timerManager, manager)
    }
}
