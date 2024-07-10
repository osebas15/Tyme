//
//  ActivitiyDummyData.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 7/8/24.
//

import Foundation


extension Activity {
    func getDummyActivities() -> [Activity] {
        // Create dummy data
        let activity1 = Activity()
        activity1.name = "parent"
        activity1.detail = "Detail of Activity 1"
        activity1.timeToComplete = 3600 // 1 hour
        activity1.onOffTimes?.append(TimeRange(start: Date(), end: Date().addingTimeInterval(30 * 60)))

        let activity2 = Activity()
        activity2.name = "small"
        activity2.detail = "Detail of Activity 2"
        activity2.timeToComplete = 900 // 15 min

        let activity3 = Activity()
        activity3.name = "big"
        activity3.detail = "Detail of Activity 3"
        activity3.timeToComplete = 2700 // 45 minutes
        activity3.onOffTimes?.append(TimeRange(start: Date(), end: Date().addingTimeInterval(30 * 60)))
        
        let activity4 = Activity()
        activity3.name = "always"
        activity3.detail = "but part of parent"
        activity3.timeToComplete = 60 * 5 // 5 minutes
        activity3.onOffTimes?.append(contentsOf: [
            TimeRange(
                start: Date(), 
                end: Date().addingTimeInterval(60)),
            TimeRange(
                start: Date().addingTimeInterval(4 * 60),
                end: Date().addingTimeInterval(5 * 60))
        ])

        // Link the activities
        activity1.next = activity2
        //activity2.previous = activity1
        activity2.next = activity3
        //activity3.previous = activity2

        // Set subActivities
        activity1.subActivities = [activity2, activity3]
        //activity2.parent = activity1
        //activity3.parent = activity1

        return [activity1, activity2, activity3]
    }
    
    func swissBurgerRecepie() -> [Activity]{
        // Create dummy data for making a Swiss burger activity
        let swissBurger = Activity()
        swissBurger.name = "Make Swiss Burger"

        // Gather Ingredients
        let gatherIngredients = Activity()
        gatherIngredients.name = "Gather ingredients"
        gatherIngredients.subActivities = [
            Activity(name: "Buns"),
            Activity(name: "Ground beef"),
            Activity(name: "Mushrooms"),
            Activity(name: "Swiss cheese"),
            Activity(name: "Cooking wine"),
            Activity(name: "Salt"),
            Activity(name: "Pepper")
        ]

        // Form patty and season with salt and pepper
        let formPatty = Activity()
        formPatty.name = "Form patty and season with salt and pepper"
        formPatty.timeToComplete = 60 // 1 minute

        // Preheat pan
        let preheatPan = Activity()
        preheatPan.name = "Preheat pan"
        preheatPan.detail = "Preheat on high"
        preheatPan.timeToComplete = 180 // 3 minutes

        // Clean mushrooms
        let cleanMushrooms = Activity()
        cleanMushrooms.name = "Clean mushrooms"
        cleanMushrooms.detail = "Use a moist paper towel"
        cleanMushrooms.timeToComplete = 150 // 2 minutes 30 seconds

        // Place patty on pan
        let placePatty = Activity()
        placePatty.name = "Place patty on pan"
        placePatty.detail = "Flip in 4 minutes"
        placePatty.timeToComplete = 240 // 4 minutes

        // Cut mushrooms
        let cutMushrooms = Activity()
        cutMushrooms.name = "Cut mushrooms"
        cutMushrooms.timeToComplete = 300 // 5 minutes

        // Flip patty
        let flipPatty = Activity()
        flipPatty.name = "Flip patty"
        flipPatty.detail = "High priority"
        flipPatty.timeToComplete = 30 // 30 seconds

        // Fry patty
        let fryPatty = Activity()
        fryPatty.name = "Fry patty"
        fryPatty.timeToComplete = 120 // 2 minutes

        // Put cheese on patty
        let putCheese = Activity()
        putCheese.name = "Put cheese on patty"
        putCheese.detail = "High priority"
        putCheese.timeToComplete = 30 // 30 seconds

        // Take burger from pan
        let takeBurger = Activity()
        takeBurger.name = "Take burger from pan"
        takeBurger.detail = "High priority"
        takeBurger.timeToComplete = 30 // 30 seconds

        // Fry mushrooms with cooking wine
        let fryMushrooms = Activity()
        fryMushrooms.name = "Fry mushrooms with cooking wine"
        fryMushrooms.detail = "High heat"
        fryMushrooms.timeToComplete = 180 // 3 minutes

        // Place mushrooms on burger, Enjoy!!!
        let placeMushrooms = Activity()
        placeMushrooms.name = "Place mushrooms on burger, Enjoy!!!"

        // Set up the hierarchy
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
        
        return [swissBurger]//, ...swissBurger.subActivities!]
    }
}

