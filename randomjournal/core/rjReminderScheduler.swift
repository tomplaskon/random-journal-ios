//
//  rjReminderScheduler.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-08.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit
import UserNotifications
import os.log

class rjReminderScheduler: NSObject {
    let notificationCenter = UNUserNotificationCenter.current()
    let reminderMgr = rjReminderMgr()
    
    static let shared = rjReminderScheduler()
    
    override private init() {
        // let's make this a singleton
        
        super.init()
    }
    
    // ensure that each day returned by getDaysThatCanBeScheduled has a reminder scheduled on it
    func updateReminders() {
        notificationCenter.getPendingNotificationRequests { (notificationRequests) in
            objc_sync_enter(self)
            let settings = rjAppSettings.shared
            
            // do some house cleaning
            self.cleanUpReminders(notificationRequests)
            
            // which days do we need to schedule?
            let daysToBeScheduled = self.getDaysNeedingToBeScheduled(notificationRequests)
            
            // get the random reminders for those days
            let reminders = self.makeRandomSchedule(
                startOfPeriodSecs: rjCommon.unixTimestampAtBeginningOfToday(),
                daysToSchedule: daysToBeScheduled,
                numRemindersPerDay: settings.getNumDailyAlerts(),
                startTimeSecs: settings.getReminderStartTime(),
                endTimeSecs: settings.getReminderEndTime()
            )
            
            // schedule the reminders
            self.scheduleReminders(reminders)
            
            objc_sync_exit(self)
        }
    }
    
    // create a schedule of reminders given all the parameters we want to satisfy
    func makeRandomSchedule(startOfPeriodSecs : Int, daysToSchedule : Set<Int>, numRemindersPerDay : Int, startTimeSecs : Int, endTimeSecs : Int) -> Array<rjReminder> {
        var reminders: [rjReminder] = [];
        for dayNum in daysToSchedule.sorted() {
            for _ in 0..<numRemindersPerDay {
                let randSecsInDay = rjCommon.getRandomInt(from: endTimeSecs, to: startTimeSecs)
                let startOfThisDaySecs = dayNum*86400
                
                let reminder = rjReminder()
                reminder.triggerTime = startOfPeriodSecs + startOfThisDaySecs + randSecsInDay
                
                reminders.append(reminder)
            }
        }
        
        return reminders
    }
    
    // register the reminders so they are actually shown
    func scheduleReminders(_ reminders : [rjReminder]) {
        for reminder in reminders {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(reminder.getTimeIntervalFromNow()), repeats: false)
            
            let content = UNMutableNotificationContent()
            content.title = "What are you doing right now?"
            content.sound = .default()
            
            let request = UNNotificationRequest(identifier: reminder.reminderId, content: content, trigger: trigger)
            
            // Schedule the request with the system.
            notificationCenter.add(request) { (error) in
                if error != nil {
                    os_log("Error schedule test reminder: %@", error.debugDescription)
                }
            }
            
            // save the reminder
            reminder.update()
        }
    }
    
    // which days already have reminders scheduled?
    func getDaysAlreadyScheduled(_ notificationRequests : [UNNotificationRequest]) -> Set<Int> {
        var daysAlreadyScheduled = Set<Int>()
        let today = Date()
        let reminders = reminderMgr.allRemindersMap()
        
        for item in notificationRequests {
            if let reminder = reminders[item.identifier] {
                let dayNum = self.getNumDays(from: today, to: reminder.getTriggerDate())
                daysAlreadyScheduled.insert(dayNum)
            }
        }
        
        return daysAlreadyScheduled
    }
    
    func getNumDays(from: Date, to: Date) -> Int {
        let calendar = Calendar.current
        let fromAtNoon = self.getDateAtMidDay(from)
        let toAtNoon = self.getDateAtMidDay(to)
        let components = calendar.dateComponents([.day], from: fromAtNoon, to: toAtNoon)
        return components.day!
    }
    
    // which days can we schedule reminders on?
    func getDaysThatCanBeScheduled() -> Set<Int> {
        return Set(1...7)
    }
    
    // which days do we still need to schedule?
    func getDaysNeedingToBeScheduled(_ notificationRequests : [UNNotificationRequest]) -> Set<Int> {
        let daysAlreadyScheduled = self.getDaysAlreadyScheduled(notificationRequests)
        let schedulableDays = self.getDaysThatCanBeScheduled()
        let daysToSchedule = schedulableDays.subtracting(daysAlreadyScheduled)
        return daysToSchedule
    }
    
    // return a Date on the same day with the time set to noon
    func getDateAtMidDay(_ date : Date) -> Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: 12, minute: 00, second: 00, of: calendar.startOfDay(for: date))!
    }
    
    // remove orphaned reminders and notification requests
    func cleanUpReminders(_ notificationRequests : [UNNotificationRequest]) {
        let testReminder = rjReminder()
        testReminder.update()
        
        let notificationRequestMap = Dictionary(uniqueKeysWithValues: notificationRequests.map{ ($0.identifier, $0) })
        
        let reminderMap = reminderMgr.allRemindersMap()
        
        // remove reminders that don't have an associated notification request
        let orphanReminderMap = reminderMap.filter { notificationRequestMap[$0.key] == nil }
        for reminder in orphanReminderMap.values {
            reminderMgr.deleteReminder(reminder)
        }
        
        // remove notification requeusts that don't have an associated reminder
        let orphanRequestMap = notificationRequestMap.filter { reminderMap[$0.key] == nil }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: Array(orphanRequestMap.keys))
    }
    
    /*
     func scheduleTestReminder() {
     // create a reminder five seconds from now
     let testReminder = rjReminder()
     testReminder.triggerTime = rjCommon.unixTimestamp() + 5;
     
     // Ask for permission for alerts
     notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
     // Enable or disable features based on authorization.
     }
     
     let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(5), repeats: false)
     
     let uuidString = UUID().uuidString
     let content = UNMutableNotificationContent()
     content.title = "What are you doing right now?"
     
     let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
     
     // Schedule the request with the system.
     notificationCenter.add(request) { (error) in
     if error != nil {
     os_log("Error schedule test reminder: %@", error.debugDescription)
     }
     }
     
     // schedule request 2
     
     let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(10), repeats: false)
     
     let content2 = UNMutableNotificationContent()
     content2.title = "What are you doing right now 2?"
     
     let request2 = UNNotificationRequest(identifier: UUID().uuidString, content: content2, trigger: trigger2)
     
     // Schedule the request with the system.
     notificationCenter.add(request2) { (error) in
     if error != nil {
     os_log("Error schedule test reminder: %@", error.debugDescription)
     }
     }
     
     getCurrentScheduleReadable() { (scheduleStr) in
     print(scheduleStr)
     }
     }
     */
    
    func getCurrentScheduleReadable(completion: @escaping (String) -> Void) {
        notificationCenter.getPendingNotificationRequests { (notifications) in
            var scheduleStr = ""
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "MMM d, h:mm:ss a"
            
            let sortedNotifs = notifications.sorted { (request1: UNNotificationRequest, request2: UNNotificationRequest) -> Bool in
                if let trigger1 = request1.trigger as? UNTimeIntervalNotificationTrigger, let trigger2 = request2.trigger as? UNTimeIntervalNotificationTrigger, let triggerDate1 = trigger1.nextTriggerDate(), let triggerDate2 = trigger2.nextTriggerDate() {
                    return triggerDate1 < triggerDate2
                }
                return false
                
            }
            
            let reminders = self.reminderMgr.allRemindersMap()
            
            for request in sortedNotifs {
                if let reminder = reminders[request.identifier] {
                    if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                        scheduleStr += dateFormatter.string(from: reminder.getTriggerDate()) + " (" + dateFormatter.string(from: trigger.nextTriggerDate()!) + ")\n"
                    } else {
                        scheduleStr += "Request with identifier " + request.identifier + " with unexpected trigger\n"
                    }
                } else {
                    scheduleStr += "Request with identifier " + request.identifier + " without reminder\n"
                }
                
                /*
                 if let intervalTrigger = item.trigger as? UNTimeIntervalNotificationTrigger {
                 let calc = Date().timeIntervalSince1970 + intervalTrigger.timeInterval
                 scheduleStr += String(calc)  + " = " + String(intervalTrigger.nextTriggerDate()!.timeIntervalSince1970) + "\n"
                 }
                 */
            }
            
            completion(scheduleStr)
        }
    }
    
    func clearReminders() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
}
