//
//  NotificationManager.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/2/24.
//
import Foundation
import UserNotifications


struct TymeNotificationManager {
    func getPermission() -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(with: [.alert, .badge, .sound]){ success, error in
            return success
        }
    }
    
    func sendWaitAfterCompletionDoneNotification(object: ActivityObject){
        guard let activityClass = object.activityClass else { return }
        
        let content = UNMutableNotificationContent()
        content.title = activityClass.name
        content.subtitle = activityClass.detail
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: activityClass.waitAfterCompletion, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: activityClass.name + ".\()", content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}
