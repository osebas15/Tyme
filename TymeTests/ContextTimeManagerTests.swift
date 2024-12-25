//
//  ContextTimeManagerTests.swift
//  TymeTests
//
//  Created by Sebastian Aguirre on 12/24/24.
//

import Testing
import SwiftData

@MainActor
struct ContextTimeManagerTests {
    
    var manager: ActivityTestManager {
        return ActivityTestManager()
    }
    
    var contextTimeManager: ContextTimeManager {
        return ContextTimeManager()
    }
    
    //stable
    @Test("STATE: stable")
    func stable() async throws {
        let manager = manager
        let contextTimeManager = contextTimeManager
        
        #expect(contextTimeManager.currentState(context: manager.container.mainContext) == .stable)
    }
    
    //waitingForUserInput
    @Test("STATE: waitingForUserInput")
    func waitingForUserInput() async throws {
        let manager = manager
        let contextTimeManager = contextTimeManager
        
        let _ = manager.startDummyClassAndGetResultingObject()
        #expect(contextTimeManager.currentState(context: manager.container.mainContext) == .waitingForUserInput)
    }
    
    //waiting for time event
    @Test("STATE: waitingForTimedEvent")
    func waitingForTimeEvent() async throws {
        let manager = manager
        let contextTimeManager = contextTimeManager
        
        let actObj = manager.startDummyClassAndGetResultingObject()
        actObj.start()
        
        #expect(contextTimeManager.currentState(context: manager.container.mainContext) == .waitingForTimedEvent)
    }
    
    @Test("STATE: returns to stable")
    func goesBackToStable() async throws {
        let manager = manager
        let contextTimeManager = contextTimeManager
        
        let actObj = manager.startDummyClassAndGetResultingObject()
        actObj.complete(context: manager.container.mainContext)
        
        #expect(contextTimeManager.currentState(context: manager.container.mainContext) == .stable)
    }
    
    //needsStateReduction

}
