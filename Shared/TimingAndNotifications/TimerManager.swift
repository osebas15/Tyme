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
    private var currentTimers = [PersistentIdentifier: Timer]()
    
    func timerExists(id: PersistentIdentifier) -> Bool {
        return currentTimers.keys.contains(id)
    }
    
    func createTimer(for timeable: TimerVariables){
        Task{
            await MainActor.run{
                let timer = Timer.scheduledTimer(
                    withTimeInterval: timeable.fireInterval,
                    repeats: false,
                    block: { timer in
                        timeable.action()
                        Task {
                            await self.endTimer(id: timeable.id)
                        }
                    })
                
                Task{
                    await self.addTimer(id: timeable.id, timer: timer)
                }
                
                RunLoop.current.add(timer, forMode: .common)
            }
        }
    }
    
    func addTimer(id: PersistentIdentifier, timer: Timer){
        if currentTimers.keys.contains([id]){
            endTimer(id: id)
        }
        currentTimers[id] = timer
    }
    
    func endTimer(id: PersistentIdentifier){
        currentTimers[id]?.invalidate()
        currentTimers.removeValue(forKey: id)
    }
}

extension TimerManager {
    struct TimerVariables: Sendable, Identifiable {
        let fireInterval: TimeInterval
        let id: PersistentIdentifier
        let action: @Sendable () -> ()
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
