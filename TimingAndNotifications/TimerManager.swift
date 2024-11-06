//
//  TimerManager.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/2/24.
//

import Foundation
import SwiftData
import SwiftUI

actor TimerManager {
    var currentTimers = [UUID: Timer]()
    
    func startTimer(container: ModelContainer, forObject objectToQuery: ActivityObject){
        
        guard
            let activityClass = objectToQuery.activityClass,
            let waitTime = activityClass.waitAfterCompletion
        else { return }
        
        let newTimer = Timer(timeInterval: waitTime, repeats: false) { timer in
            Task {
                let actorIsolatedObject = await objectToQuery.queriedCopy(container: container)
                await MainActor.run { actorIsolatedObject.checkAndContinueState(context: container.mainContext)
                }
                await self.endTimer(id: actorIsolatedObject.id)
            }
        }
        
        currentTimers[objectToQuery.id] = newTimer
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
