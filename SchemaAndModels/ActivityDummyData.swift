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
}

