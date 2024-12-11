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
    var newContainer: ModelContainer {
        let container = ModelHelper().getTestContainer()
        return container
    }
    
    @Test("Home Object loads")
    func homeObject() async throws {
        let container = newContainer
        let test = ModelHelper().getHomeObject(container: container)
        
        #expect(test.activityClass?.name ?? "empty actClass" == "Home")
    }

    
    @Test("Start test activity and its subactivities")
    func start() async throws {
        let container = newContainer
        let dummyActivity = ActivityClass.dummyActivity()
        let parentObj = ModelHelper().getHomeObject(container: container)
        
        container.mainContext.insert(dummyActivity)
        dummyActivity.start(context: container.mainContext, parentObject: parentObj, stepNumber: 0)
        let startedActivity = parentObj.unOrderedActivities.first!
        
        //activity goes into a started state (creates activity object and adds it to the parent), all sub activities as well
        #expect(startedActivity.activityClass!.id == dummyActivity.id)
        #expect(startedActivity.unOrderedActivities.first!.activityClass!.id == dummyActivity.unOrderedSubActivities.first!.id)
    }
}
