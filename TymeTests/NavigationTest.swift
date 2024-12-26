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
    var nav = NavigationStore()
    
    init(active: Bool = false) {
        if active {
            let _ = self.activity.startDummyClassAndGetResultingObject()
        }
       
        //let _ = nav.consumeAction(action: .goToLanding, context: activity.container.mainContext)
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
            
            #expect(manager.nav.focusedActClass == nil)
            #expect(manager.nav.focusedActObj == nil)
        }
        
        @Test("ACTIVE START: Start in active view if home object has subactivities")
        func startsActive() async throws {
            let manager = NavigationTestManager()
            let sample = manager.activity.startDummyClassAndGetResultingObject()
            
            manager.nav.consumeAction(action: .goToLanding, context: manager.activity.container.mainContext)
            
            #expect(manager.nav.focusedActObj?.activityClass?.name == sample.activityClass?.name)
        }
    }
    
    @MainActor
    @Suite("Activity Flow")
    struct ActivityFlow {
        @Test("ACTIVE: Initial start")
        func startActivity() async throws {
            let manager = NavigationTestManager(active: true)
            let dummyAct = manager.activity.dummyActivity
            let parentObj = manager.activity.parentObj
            
            let _ = manager.nav.consumeAction(
                action: .startAction(actClass: dummyAct, parentObj: parentObj),
                context: manager.activity.container.mainContext)
                
            let newAct = parentObj.unOrderedActivities.first(where: { $0.activityClass == dummyAct })
            
            #expect( manager.nav.focusedActObj == newAct )
        }
        
        @Test("ACTIVE: go to next")
        func goToNext() async throws {
            let manager = NavigationTestManager(active: true)
            manager.activity.dummyActivity.addSteps(activities: manager.activity.sampleActivities)
            
            let sampleObj = manager.activity.startDummyClassAndGetResultingObject()
            let nextClass = manager.activity.dummyActivity.orderedSteps.first
            
            manager.nav.consumeAction(action: .completeAction(sampleObj), context: manager.activity.container.mainContext)
            
            
            #expect(manager.nav.focusedActObj?.activityClass?.name == nextClass?.name)
            /*
            switch manager.nav.currentView {
            case .landing(focus: _, activeActivity: let activeObj) where activeObj?.activityClass == nextClass:
                #expect(true)
            case .landing(focus: _, activeActivity: let activeObj):
                #expect(Bool(false), "\(activeObj?.activityClass?.name) is not \(nextClass?.name)")
            default :
                #expect(Bool(false), "did not expect \(manager.nav.currentView.toString())")
            }
             */
        }
    }
    
    @MainActor
    @Suite("Activity Edit And Create")
    struct ActivityEditAndCreate {
        @Test("Focusing classes")
        func focusActivities() async throws {
            let manager = NavigationTestManager()
            
            for act in manager.activity.sampleActivities{
                manager.nav.consumeAction(action: .focusActClass(act), context: manager.activity.container.mainContext)
                #expect(manager.nav.focusedActClass == act)
            }
        }
    }
}
