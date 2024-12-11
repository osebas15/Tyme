//
//  ActivityTests.swift
//  TymeTests
//
//  Created by Sebastian Aguirre on 12/10/24.
//

import Testing
import SwiftData

@MainActor
struct ActivityTests {
    
    @MainActor
    struct SetupManager {
        let container = {
            let container = ModelHelper().getTestContainer()
            return container
        }()
        
        let dummyActivity = ActivityClass.dummyActivity()
        let sampleActivities = ActivityClass.sampleActivitySteps()
        let parentObj: ActivityObject
        
        init(){
            parentObj = ModelHelper().getHomeObject(container: container)
            container.mainContext.insert(dummyActivity)
            sampleActivities.forEach { container.mainContext.insert($0) }
        }
        
        func startDummyClassAndGetResultingObject() -> ActivityObject {
            dummyActivity.start(context: container.mainContext, parentObject: parentObj, stepNumber: 0)
            return parentObj.unOrderedActivities.first!
        }
    }
    
    @Test("Home Object loads")
    func homeObject() async throws {
        let test = ModelHelper().getHomeObject(container: SetupManager().container)
        
        #expect(test.activityClass?.name ?? "empty actClass" == "Home")
    }
    
    @Test("Object creation works")
    func startasdf() async throws {}
    
    @Test("Start test activity and its subactivities")
    func start() async throws {
        let setup = SetupManager()
        
        let startedActivity = setup.startDummyClassAndGetResultingObject()
        
        #expect(startedActivity.activityClass!.id == setup.dummyActivity.id)
        #expect(startedActivity.unOrderedActivities.first!.activityClass!.id == setup.dummyActivity.unOrderedSubActivities.first!.id)
    }
    
    @Test("add steps adds correctly")
    func addStepsToDummyAct() async throws {
        let setup = SetupManager()
        
        setup.dummyActivity.addSteps(activities: setup.sampleActivities)
        
        #expect(setup.dummyActivity.orderedSteps.elementsEqual(setup.sampleActivities))
        //class model has steps: [Class], instead of next
    }
    
    @Test("get next object in steps")
    func getNext() async throws {
        let setup = SetupManager()
        setup.dummyActivity.addSteps(activities: setup.sampleActivities)
        
        let processObj = setup.startDummyClassAndGetResultingObject()
        let next = processObj.getNextClassIfInChain(context: setup.container.mainContext)

        #expect(next == setup.sampleActivities.first!)
        //let testObj = processObj.getNextIfInChain()
    }

    @Test("completes object to a done state")
    func completeObject() async throws {
        #expect(Bool(false))
    }
    
    
    @Test("Moving through steps: object currentStep shows the correct step in the process")
    func moveThroughStep() async throws {
        let setup = SetupManager()
        
        setup.dummyActivity.addSteps(activities: setup.sampleActivities)
        setup.dummyActivity.start(context: setup.container.mainContext, parentObject: setup.parentObj, stepNumber: 0)
        
        let processObj = setup.parentObj.unOrderedActivities.first!
        #expect(Bool(false))
        //#expect(processObj.currentStep.activityClass == setup.dummyActivity.currentStep.activityClass)
        
        //object model has currentStep: [Object] instead of currentStep: Int
    }
}
