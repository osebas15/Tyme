//
//  NotificationManager.swift
//  Tyme
//
//  Created by Sebastian Aguirre on 11/2/24.
//
import Foundation
import UserNotifications


actor TymeNotificationManager {
    func getPermission(callback: @escaping (Bool, Error?) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [
            .alert, .badge, .sound
        ]){ success, error in
            callback(success, error)
        }
    }
    
    func sendWaitAfterCompletionDoneNotification(info: NotificationInfo){
        getPermission { success, error in
            guard success == true else { return }
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(info.id)"])
            
            let content = UNMutableNotificationContent()
            content.title = info.title
            content.subtitle = info.subtitle
            content.sound = UNNotificationSound.default
            content.interruptionLevel = .timeSensitive

            // show this notification five seconds from now
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: info.timeToWait , repeats: false)

            // choose a random identifier
            let request = UNNotificationRequest(identifier: "\(info.id)", content: content, trigger: trigger)

            // add our notification request
            UNUserNotificationCenter.current().add(request)
        }
    }
}

extension TymeNotificationManager {
    struct NotificationInfo: Identifiable {
        let title: String
        let subtitle: String
        let timeToWait: TimeInterval
        let id: UUID
    }
}
