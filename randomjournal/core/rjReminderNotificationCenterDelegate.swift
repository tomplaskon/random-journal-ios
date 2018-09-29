//
//  rjReminderNotificationCenterDelegate.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-18.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit
import UserNotifications

class rjReminderNotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent: UNNotification,
                                withCompletionHandler: @escaping (UNNotificationPresentationOptions)->()) {
        withCompletionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive: UNNotificationResponse,
                                withCompletionHandler: @escaping ()->()) {
        withCompletionHandler()
    }
}
