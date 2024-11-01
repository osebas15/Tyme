//
//  ActivitiyDummyData.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 7/8/24.
//

import Foundation
import SwiftData

@MainActor
struct ActivityDummyData {
    
    let microwavedPotatoRecepie: ActivityClass = {
        let gatherIngridientsPotatoes = ActivityClass(
            name: "Microwaved potatoes ingridients"
        )
        [
            "Baby Potatoes",
            "Cheese",
            "Microwave safe small plate",
            "fork and knife"
        ].forEach{
            gatherIngridientsPotatoes.addSubActivity(
                activity: ActivityClass(name: $0)
            )
        }
        let pokeHoles = ActivityClass(
            name: "Poke holes in the potatoes",
            detail: "so the potatoes don't explode in the microwave"
        )
        let microwavePotatoes = ActivityClass(
            name: "Microwave potatoes for 5 minutes",
            waitAfterCompletion: 5 * 60
        )
        let cutPotatoes = ActivityClass(
            name: "Cut the potatoes and add cheese"
        )
        
        gatherIngridientsPotatoes.addSteps(activities: [
            pokeHoles,
            microwavePotatoes,
            cutPotatoes
        ])
        
        return gatherIngridientsPotatoes
    }()
    
    let friedEggs: ActivityClass = {
        let eggsIngridients = ActivityClass(
            name: "What you need to fry eggs"
        )
        [
            "Butter",
            "Eggs",
            "Frying Pan with cover",
            "Spatula"
        ].forEach{
            eggsIngridients.addSubActivity(activity: ActivityClass(name:$0))
        }
        
        let heatUpPanMeltButter = ActivityClass(
            name: "heat up the pan and melt butter",
            waitAfterCompletion: 60
        )
        let cookUncovered = ActivityClass(
            name: "fry uncovered",
            waitAfterCompletion: 60
        )
        let cookCovered = ActivityClass(
            name: "cover frying pan",
            waitAfterCompletion: 60
        )
        let removeFromPan = ActivityClass(
            name: "remove from frying pan"
        )
        
        eggsIngridients.addSteps(activities: [
            heatUpPanMeltButter,
            cookUncovered,
            cookCovered,
            removeFromPan
        ])
        
        return eggsIngridients
    }()
    
    let coffee: ActivityClass = {
        let coffeeIngridients = ActivityClass(
            name: "make coffee with a coffee maker"
        )
        [
            "Water",
            "Ground coffee",
            "Coffee mug",
            "Milk"
        ].forEach {
            coffeeIngridients.addSubActivity(activity: ActivityClass(name: $0))
        }
        
        let coffeeMaker = ActivityClass(
            name: "Put water and ground coffee in coffee maker and start it",
            waitAfterCompletion: 5 * 60
        )
        let serve = ActivityClass(
            name: "Serve in mug with milk"
        )
        
        coffeeIngridients.addSteps(activities: [
            coffeeMaker,
            serve
        ])
        
        return coffeeIngridients
    }()
    
    let toast: ActivityClass = {
        let toast = ActivityClass(
            name: "Ingridients for Toast"
        )
        toast.addSubActivity(activity: ActivityClass(name: "bread"))
        
        let toaster = ActivityClass(
            name: "Add to toaster and start",
            waitAfterCompletion: 3 * 60
        )
        let serveToast = ActivityClass(
            name: "Serve toast"
        )
        
        toast.addSteps(activities: [
            toaster,
            serveToast
        ])
        
        return toast
    }()
    
    func insertQuickBreakfastRecepie(into container: ModelContainer){
        let recepie = ActivityClass(
            name: "Quick Breakfast",
            detail: "a quick hearty breakfast with cheesy potatoes, eggs, toast and coffee for an easy morning!"
        )
        [
            coffee,
            friedEggs,
            microwavedPotatoRecepie,
            toast
        ].forEach{
            recepie.addSubActivity(activity: $0)
        }
        
        container.mainContext.insert(recepie)
        
        var fd = FetchDescriptor(predicate: ModelHelper().homeActivityPredicate)
        fd.fetchLimit = 1
        let result = try? container.mainContext.fetch(fd)
        if (!(result?.isEmpty ?? true)){
            result![0].addSubActivity(activity: recepie)
        }
    }

    func insertSwissBurgerRecepie(into container: ModelContainer) {
        // Create dummy data for making a Swiss burger ActivityClass
        let swissBurger = ActivityClass(name: "Swiss Burger Recepie")
        swissBurger.detail = "make a delicous homemade swiss burger \n /n by Sebastian Aguirre"
        
        // Gather Ingredients
        let gatherIngredients = ActivityClass(name: "Gather ingredients")
        //gatherIngredients.subActivities = [
        [ActivityClass(name: "Buns"),
            ActivityClass(name: "Ground beef"),
            ActivityClass(name: "Mushrooms"),
            ActivityClass(name: "Swiss cheese"),
            ActivityClass(name: "Cooking wine"),
            ActivityClass(name: "Salt"),
            ActivityClass(name: "Pepper")
        ].forEach { gatherIngredients.addSubActivity(activity: $0) }
        
        // Preheat pan
        let preheatPan = ActivityClass(name: "Preheat pan")
        preheatPan.timeToComplete = 180 // 3 minutes
        
        gatherIngredients.next = preheatPan
        
        // Clean mushrooms
        let cleanMushrooms = ActivityClass(name: "Clean mushrooms")
        cleanMushrooms.detail = "Use a moist paper towel to clean the mushrooms"
        cleanMushrooms.timeToComplete = 60 // 1 minutes
        
        preheatPan.next = cleanMushrooms
        
        // Cut mushrooms
        let cutMushrooms = ActivityClass(name: "Cut mushrooms")
        cutMushrooms.timeToComplete = 120 // 2 minutes
        
        cleanMushrooms.next = cutMushrooms
        
        // Form patty and season with salt and pepper
        let formPatty = ActivityClass(name: "Season with salt and pepper and form patty")
        formPatty.timeToComplete = 60 // 1 minute
        
        cutMushrooms.next = formPatty
        
        // Place patty on pan
        let placePatty = ActivityClass(name: "Place patty on pan")
        placePatty.detail = "Flip in 4 minutes"
        placePatty.timeToComplete = 240 // 4 minutes
        
        formPatty.next = placePatty
        
        // Flip patty
        let flipPatty = ActivityClass(name: "Flip patty and fry for 2 more minutes")
        flipPatty.detail = "High priority"
        flipPatty.timeToComplete = 150 // 2.5 minutes
        
        placePatty.next = flipPatty
        
        // Put cheese on patty
        let putCheese = ActivityClass(name: "Put cheese on patty")
        putCheese.detail = "High priority"
        putCheese.timeToComplete = 30 // 30 seconds
        
        placePatty.next = putCheese
        
        // Take burger from pan
        let takeBurger = ActivityClass(name: "Take burger from pan")
        takeBurger.detail = "High priority"
        //takeBurger.timeToComplete = 30 // 30 seconds
        
        putCheese.next = takeBurger
        
        // Fry mushrooms with cooking wine
        let fryMushrooms = ActivityClass(name: "Fry mushrooms with cooking wine")
        fryMushrooms.detail = "High heat, continously flip"
        fryMushrooms.timeToComplete = 180 // 3 minutes
        
        takeBurger.next = fryMushrooms
        
        // Place mushrooms on burger, Enjoy!!!
        let placeMushrooms = ActivityClass(name: "Place mushrooms on burger, Enjoy!!!")
        
        fryMushrooms.next = placeMushrooms
        
        swissBurger.addSubActivity(activity: gatherIngredients)
        /*[gatherIngredients,
            formPatty,
            preheatPan,
            cleanMushrooms,
            placePatty,
            cutMushrooms,
            flipPatty,
            putCheese,
            takeBurger,
            fryMushrooms,
            placeMushrooms
        ].forEach { swissBurger.addSubActivity(activity: $0) }
        */
        
        let swissBurgerRecepie = [swissBurger]// + swissBurger.subActivities
        
        var fd = FetchDescriptor(predicate: ModelHelper().homeActivityPredicate)
        fd.fetchLimit = 1
        let result = try? container.mainContext.fetch(fd)
        if (!(result?.isEmpty ?? true)){
            result![0].addSubActivity(activity: swissBurger)//.subActivities.append(swissBurger)
            //swissBurger.createdFrom = result![0]
        }
    }
}
