//
//  AppDelegate.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-05.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift

extension UIViewController {
    var appDelegate:rjAppDelegate {
        return UIApplication.shared.delegate as! rjAppDelegate
    }
}

@UIApplicationMain
class rjAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notificationDelegate = rjReminderNotificationCenterDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // register our notification configuration
        registerNotificationCenterDelegate()
        
        // make sure a full schedule of reminders have been scheduled
        handleUpdatingReminders()
        
        applyGlobalStyles()
        
        return true
    }

    private func registerNotificationCenterDelegate() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = notificationDelegate
    }
    
    private func handleUpdatingReminders() {
        if rjAppSettings.shared.areRemindersEnabled() {
            rjReminderScheduler.shared.updateReminders()
        }
    }
    
    private func applyGlobalStyles() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .selected)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

