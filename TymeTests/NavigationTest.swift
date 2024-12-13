//
//  NavigationTest.swift
//  TymeTests
//
//  Created by Sebastian Aguirre on 12/11/24.
//

import Foundation
import Testing
import SwiftData


@MainActor
struct NavigationTestManager {
    
    var activity = ActivityTestManager()
    var nav = NavigationRedux()
    
    init(active: Bool = false) {
        if active {
            let _ = self.activity.startDummyClassAndGetResultingObject()
        }
        nav.reduce(context: activity.container.mainContext, action: .goToLanding)
    }
}

@MainActor
struct NavigationTest {

    
    @MainActor
    @Suite("Landing")
    struct LandingTestSuite {
        @Test("INACTIVE START: Start in select (Home) activity view")
        func startsInactive() async throws {
            let manager = NavigationTestManager()
            
            #expect(manager.nav.navStack.last == NavigationRedux.Action.landed(active: false))
        }
        
        @Test("ACTIVE START: Start in active view if home object has subactivities")
        func startsActive() async throws {
            let manager = NavigationTestManager(active: true)
            let _ = manager.activity.startDummyClassAndGetResultingObject()
            
            //let _ = manager.nav.reduce LandingAction(context: manager.activity.container.mainContext)
            
            let homeObj = manager.activity.parentObj
            
            print("count is: \(homeObj.unOrderedActivities.count)")
            #expect(manager.nav.navStack.last == NavigationRedux.Action.landed(active: true))
        }
    }
}