//
//  ActivityTests.swift
//  TymeTests
//
//  Created by Sebastian Aguirre on 12/10/24.
//

import Testing
import SwiftData

@MainActor
struct ActivityTestManager {
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
    //case main, started, inSubsteps, done, error
    @Test("HOME OBJECT: loads")
    func homeObject() async throws {
        let setup = ActivityTestManager()
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
        let setup = ActivityTestManager()
        setup.dummyActivity.addSteps(activities: setup.sampleActivities)
        setup.parentObj.createSubActivity(
            context: setup.container.mainContext,
            activityClass: setup.dummyActivity
        )
        let createdObject = setup.parentObj.unOrderedActivities.first!
        let initialState = createdObject.verifyCurrentState()
        #expect(initialState == .waitingToStart)
        
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
    
    @Test("START: activity and its subactivities are started correctly")
    func start() async throws {
        let setup = ActivityTestManager()
        
        let startedActivity = setup.startDummyClassAndGetResultingObject()
        
        #expect(startedActivity.activityClass!.id == setup.dummyActivity.id)
        #expect(startedActivity.unOrderedActivities.first!.activityClass!.id == setup.dummyActivity.unOrderedSubActivities.first!.id)
    }
    
    @Test("STEPS: add steps in correct order")
    func addStepsToDummyAct() async throws {
        let setup = ActivityTestManager()
        
        setup.dummyActivity.addSteps(activities: setup.sampleActivities)
        
        #expect(setup.dummyActivity.orderedSteps.elementsEqual(setup.sampleActivities))
    }
    
    @Test("STEPS: creates next object in steps")
    func getNext() async throws {
        let setup = ActivityTestManager()
        setup.dummyActivity.addSteps(activities: setup.sampleActivities)
        
        let processObj = setup.startDummyClassAndGetResultingObject()
        #expect(processObj.activityClass?.name == setup.dummyActivity.name)
        
        processObj.complete(context: setup.container.mainContext)
        #expect(processObj.currentStep.activityClass?.name == setup.dummyActivity.orderedSteps.first?.name)
        
        processObj.complete(context: setup.container.mainContext)
        let currentClass = processObj.currentStep.activityClass
        #expect(currentClass!.name == setup.sampleActivities[1].name)
        #expect(processObj.currentStep.firstStep.activityClass?.name == processObj.activityClass?.name)
    }
    
    @Test("STEPS: objects in a step sequence show correct state based on currentStep, in the middle of one and at the end of one")
    func stepSequenceStates() async throws {
        let setup = ActivityTestManager()
        
        setup.dummyActivity.addSteps(activities: setup.sampleActivities)
        setup.dummyActivity.waitAfterCompletion = 1
        
        let initialObj = setup.startDummyClassAndGetResultingObject()
        
        initialObj.start()
        #expect(initialObj.verifyCurrentState() == .started)
        
        initialObj.complete(context: setup.container.mainContext)
        #expect(initialObj.verifyCurrentState() == .inSubsteps)
        
        #expect(initialObj.currentStep.verifyCurrentState() == .waitingToStart)
        
        initialObj.currentStep.complete(context: setup.container.mainContext)
        #expect(initialObj.currentStep.activityClass?.name == setup.sampleActivities[0].name)
        #expect(initialObj.currentStep.getNextStep(context: setup.container.mainContext) == initialObj)
        
        initialObj.currentStep.complete(context: setup.container.mainContext)
        #expect(initialObj.currentStep.activityClass?.name == setup.sampleActivities[1].name)
        
        //let nextStep = initialObj.currentStep
        
        //#expect(nextStep != currentStep)
        
        
        //go from .waiting to .waiting and not the same the right number of times
        
        //currentStep.complete(context: ModelContext)
        
        //TODO: Move past final step and make sure it goes to done
        
        //TODO: ACTUAL focus state functionality modularized: start, complete
        /*
        #expect(Bool)
        #expect(Bool)
        #expect(Bool)
         */
    }
    
    @Test("COMPLETE: getNext returns nil if no substeps")
    func getNextWhenNoSteps() async throws {
        let setup = ActivityTestManager()
        let obj = setup.startDummyClassAndGetResultingObject()
        
        let next = obj.getNextStep(context: setup.container.mainContext)
        
        #expect(next == nil)
    }

    @Test("COMPLETE: completes object to a done state")
    func completeObject() async throws {
        let setup = ActivityTestManager()
        
        let startedActivity = setup.startDummyClassAndGetResultingObject()
        startedActivity.complete(context: setup.container.mainContext)
        
        #expect(startedActivity.verifyCurrentState() == .done)
    }
}
