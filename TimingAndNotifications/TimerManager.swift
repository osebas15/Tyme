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
    private var currentTimers = [UUID: Timer]()
    
    func timerExists(id: UUID) -> Bool {
        return currentTimers.contains(where: {$0.key == id})
    }
    
    func createTimer(for timeable: TimerVariables){
        currentTimers[timeable.id] = Timer(
            fire: timeable.fireDate,
            interval: 0,
            repeats: false,
            block: { timer in
                timeable.action()
                Task {
                    await self.endTimer(id: timeable.id)
                }
            })
    }
    
    func endTimer(id: UUID){
        currentTimers[id]?.invalidate()
        currentTimers.removeValue(forKey: id)
    }
}

extension TimerManager {
    struct TimerVariables: Sendable {
        let fireDate: Date
        let id: UUID
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
