//
//  ActivitiyDummyData.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 7/8/24.
//

import Foundation
import SwiftData

extension ActivityClass {
    static private var dummyActivities: [ActivityClass]?
    static func getDummyActivities(insertIntoContainer container: ModelContainer? = nil) -> [ActivityClass] {
        if dummyActivities == nil{
            // Create dummy data
            let ActivityClass1 = ActivityClass(name: "parent")
            ActivityClass1.detail = "Detail of ActivityClass 1"
            ActivityClass1.timeToComplete = 3600 // 1 hour
            //ActivityClass1.onOffTimes?.append(TimeRange(start: Date(), end: Date().addingTimeInterval(30 * 60)))

            let ActivityClass2 = ActivityClass(name: "small")
            ActivityClass2.detail = "Detail of ActivityClass 2"
            ActivityClass2.timeToComplete = 900 // 15 min

            let ActivityClass3 = ActivityClass(name: "big")
            ActivityClass3.detail = "Detail of ActivityClass 3"
            ActivityClass3.timeToComplete = 2700 // 45 minutes
            //ActivityClass3.onOffTimes?.append(TimeRange(start: Date(), end: Date().addingTimeInterval(30 * 60)))
            /*
            let ActivityClass4 = ActivityClass()
            ActivityClass4.name = "always"
            ActivityClass4.detail = "but part of parent"
            ActivityClass4.timeToComplete = 60 * 5 // 5 minutes
            ActivityClass4.onOffTimes?.append(contentsOf: [
                TimeRange(
                    start: Date(),
                    end: Date().addingTimeInterval(60)),
                TimeRange(
                    start: Date().addingTimeInterval(4 * 60),
                    end: Date().addingTimeInterval(5 * 60))
            ])*/

            dummyActivities = [ActivityClass1, ActivityClass2, ActivityClass3]
            
            if let container = container {
                ActivityClass.noDupInsert(container: container, toInsert: dummyActivities!)
            }
            
            // Link the activities
            ActivityClass1.next = ActivityClass2
            ActivityClass2.next = ActivityClass3

            // Set subActivities
            ActivityClass1.subActivities = [ActivityClass2, ActivityClass3]
        }
        return dummyActivities!
    }
    
    static private var swissBurgerRecepie: [ActivityClass]?
    static func getSwissBurgerRecepie(insertIntoContainer container: ModelContainer? = nil) -> [ActivityClass]{
        if swissBurgerRecepie == nil {
            // Create dummy data for making a Swiss burger ActivityClass
            let swissBurger = ActivityClass(name: "Swiss Burger Recepie")
            swissBurger.detail = "make a delicous homemade swiss burger \n /n by Sebastian Aguirre"
            
            // Gather Ingredients
            let gatherIngredients = ActivityClass(name: "Gather ingredients")
            gatherIngredients.subActivities = [
                ActivityClass(name: "Buns"),
                ActivityClass(name: "Ground beef"),
                ActivityClass(name: "Mushrooms"),
                ActivityClass(name: "Swiss cheese"),
                ActivityClass(name: "Cooking wine"),
                ActivityClass(name: "Salt"),
                ActivityClass(name: "Pepper")
            ]
            
            // Form patty and season with salt and pepper
            let formPatty = ActivityClass(name: "Form patty and season with salt and pepper")
            formPatty.timeToComplete = 60 // 1 minute
            
            // Preheat pan
            let preheatPan = ActivityClass(name: "Preheat pan")
            preheatPan.timeToComplete = 180 // 3 minutes
            
            // Clean mushrooms
            let cleanMushrooms = ActivityClass(name: "Clean mushrooms")
            cleanMushrooms.detail = "Use a moist paper towel to clean the mushrooms"
            cleanMushrooms.timeToComplete = 150 // 2 minutes 30 seconds
            
            // Place patty on pan
            let placePatty = ActivityClass(name: "Place patty on pan")
            placePatty.detail = "Flip in 4 minutes"
            placePatty.timeToComplete = 240 // 4 minutes
            
            // Cut mushrooms
            let cutMushrooms = ActivityClass(name: "Cut mushrooms")
            cutMushrooms.timeToComplete = 300 // 5 minutes
            
            // Flip patty
            let flipPatty = ActivityClass(name: "Flip patty")
            flipPatty.detail = "High priority"
            flipPatty.timeToComplete = 30 // 30 seconds
            
            // Fry patty
            let fryPatty = ActivityClass(name: "Fry patty")
            fryPatty.timeToComplete = 120 // 2 minutes
            
            // Put cheese on patty
            let putCheese = ActivityClass(name: "Put cheese on patty")
            putCheese.detail = "High priority"
            putCheese.timeToComplete = 30 // 30 seconds
            
            // Take burger from pan
            let takeBurger = ActivityClass(name: "Take burger from pan")
            takeBurger.detail = "High priority"
            takeBurger.timeToComplete = 30 // 30 seconds
            
            // Fry mushrooms with cooking wine
            let fryMushrooms = ActivityClass(name: "Fry mushrooms with cooking wine")
            fryMushrooms.detail = "High heat"
            fryMushrooms.timeToComplete = 180 // 3 minutes
            
            // Place mushrooms on burger, Enjoy!!!
            let placeMushrooms = ActivityClass(name: "Place mushrooms on burger, Enjoy!!!")
            
            swissBurger.subActivities = [
                gatherIngredients,
                formPatty,
                preheatPan,
                cleanMushrooms,
                placePatty,
                cutMushrooms,
                flipPatty,
                fryPatty,
                putCheese,
                takeBurger,
                fryMushrooms,
                placeMushrooms
            ]
            
            swissBurgerRecepie = [swissBurger] + swissBurger.subActivities
            
            if let container = container {
                ActivityClass.noDupInsert(container: container, toInsert: swissBurgerRecepie!)
                
                Task {@MainActor in
                    var fd = FetchDescriptor(predicate: ModelHelper.shared.homeActivityPredicate)
                    fd.fetchLimit = 1
                    let result = try? container.mainContext.fetch(fd)
                    if (!(result?.isEmpty ?? true)){
                        result![0].subActivities.append(swissBurger)
                    }
                }
            }
        }
        
        return swissBurgerRecepie!
    }
    
    static func noDupInsert(container: ModelContainer, toInsert: [ActivityClass]){
        for model in toInsert {
            let modelId = model.id
            let predicate = #Predicate <ActivityClass> { idableModel in
                return idableModel.id == modelId
            }
            
            Task {@MainActor in
                var fd = FetchDescriptor(predicate: predicate)
                fd.fetchLimit = 1
                let result = try? container.mainContext.fetch(fd)
                
                if (result?.isEmpty ?? false){
                    container.mainContext.insert(model)
                }
            }
        }
    }
}

