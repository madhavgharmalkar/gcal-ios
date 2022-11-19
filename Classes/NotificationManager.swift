//
//  NotificationManager.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 11/18/22.
//

import Foundation

@objc class NotificationManager: NSObject {
    @objc static func applicationRegisterForLocalNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                // Handle the error here.
            }
            // Enable or disable features based on the authorization.
            print("notifications granted: ", granted)
        }
    }
    
    @objc static func clearAllLocalNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }
}
