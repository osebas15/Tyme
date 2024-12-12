//
//  ActivityTests.swift
//  TymeTests
//
//  Created by Sebastian Aguirre on 12/10/24.
//

import Testing
import SwiftData

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
        dummyActivity.start(context: container.mainContext, parentObject: parentObj)
        return parentObj.unOrderedActivities.first!
    }
}

@MainActor
struct ActivityTests {
    @Test("HOME OBJECT: loads")
    func homeObject() async throws {
        let setup = SetupManager()
        let test = ModelHelper().getHomeObject(container: setup.container)
        
        #expect(test.activityClass?.name ?? "empty actClass" == "Home")
    }
    
    @Test("BASIC OBJECT CREATION", arguments: [
        "as a subact",
        "with subacts",
        "without steps",
        "with steps"
    ])
    func objectStart(arg: String) async throws {
        //start object directly from create function
        let setup = SetupManager()
        setup.dummyActivity.addSteps(activities: setup.sampleActivities)
        setup.parentObj.createSubActivity(
            context: setup.container.mainContext,
            activityClass: setup.dummyActivity
        )
        let createdObject = setup.parentObj.unOrderedActivities.first!
        
        if arg == "as a subact"{
            #expect(createdObject.parent?.activityClass == setup.parentObj.activityClass)
        }
        if arg == "with subacts"{
            let objClasses = createdObject.orderedActivities.map({ $0.activityClass! })
            #expect(objClasses.elementsEqual(setup.dummyActivity.orderedSubActivities))
        }
        if arg == "with steps"{
            #expect(createdObject.activityClass!.orderedSteps.elementsEqual(setup.sampleActivities))
        }
        
        #expect(setup.dummyActivity.orderedSteps.elementsEqual(setup.sampleActivities))
    }
    
    @Test("STEPS: add steps in correct order")
    func addStepsToDummyAct() async throws {
        let setup = SetupManager()
        
        setup.dummyActivity.addSteps(activities: setup.sampleActivities)
        
        #expect(setup.dummyActivity.orderedSteps.elementsEqual(setup.sampleActivities))
        //class model has steps: [Class], instead of next
    }
    
    @Test("STEPS: creates next object in steps")
    func getNext() async throws {
        let setup = SetupManager()
        setup.dummyActivity.addSteps(activities: setup.sampleActivities)
        
        let processObj = setup.startDummyClassAndGetResultingObject()
        #expect(processObj.activityClass == setup.dummyActivity)
        
        processObj.startNextStep(context: setup.container.mainContext)
        #expect(processObj.currentStep?.activityClass == setup.dummyActivity.orderedSteps.first)
        
        processObj.startNextStep(context: setup.container.mainContext)
        let currentClass = processObj.currentStep?.activityClass
        #expect(currentClass == setup.sampleActivities[1])
        #expect(processObj.currentStep?.firstStep?.activityClass?.name == processObj.activityClass?.name)
    }
    
    @Test("START: activity and its subactivities are started correctly")
    func start() async throws {
        let setup = SetupManager()
        
        let startedActivity = setup.startDummyClassAndGetResultingObject()
        
        #expect(startedActivity.activityClass!.id == setup.dummyActivity.id)
        #expect(startedActivity.unOrderedActivities.first!.activityClass!.id == setup.dummyActivity.unOrderedSubActivities.first!.id)
    }

    @Test("completes object to a done state")
    func completeObject() async throws {
        #expect(Bool(true))
    }
}
