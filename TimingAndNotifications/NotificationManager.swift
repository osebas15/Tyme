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
    
    
}
