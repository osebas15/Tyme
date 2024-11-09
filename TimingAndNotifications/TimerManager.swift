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
        print(timeable.fireInterval.description)
        DispatchQueue.main.async { [self] in
            let timer = Timer.scheduledTimer(
                withTimeInterval: timeable.fireInterval,
                repeats: false,
                block: { timer in
                    print("in timer")
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
    
    func addTimer(id: UUID, timer: Timer){
        currentTimers[id] = timer
    }
    
    func endTimer(id: UUID){
        currentTimers[id]?.invalidate()
        currentTimers.removeValue(forKey: id)
    }
}

extension TimerManager {
    struct TimerVariables: Sendable {
        let fireInterval: TimeInterval
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
