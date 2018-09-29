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
    
    // ensure that each day returned by getDaysThatCanBeScheduled has a reminder scheduled on it
    func updateReminders() {
        notificationCenter.getPendingNotificationRequests { (notificationRequests) in
            let settings = rjAppSettings()
            
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
        }
    }
    
    // create a schedule of reminders given all the parameters we want to satisfy
    func makeRandomSchedule(startOfPeriodSecs : Int, daysToSchedule : Set<Int>, numRemindersPerDay : Int, startTimeSecs : Int, endTimeSecs : Int) -> Array<rjReminder> {
        var reminders: [rjReminder] = [];
        for dayNum in daysToSchedule.sorted() {
            for _ in 0..<numRemindersPerDay {
                let randSecsInDay = Int(arc4random_uniform(UInt32(endTimeSecs-startTimeSecs)) + UInt32(startTimeSecs))
                let startOfThisDaySecs = dayNum*86400
                
                let reminder = rjReminder()
                reminder.time = startOfPeriodSecs + startOfThisDaySecs + randSecsInDay
                
                reminders.append(reminder)
            }
        }
        
        return reminders
    }
    
    // register the reminders so they are actually shown
    func scheduleReminders(_ reminders : [rjReminder]) {
        for reminder in reminders {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(reminder.getTimeIntervalFromNow()), repeats: false)
            
            let uuidString = UUID().uuidString
            let content = UNMutableNotificationContent()
            content.title = "What are you doing right now?"
            content.sound = .default()
            
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
            // Schedule the request with the system.
            notificationCenter.add(request) { (error) in
                if error != nil {
                    os_log("Error schedule test reminder: %@", error.debugDescription)
                }
            }
        }
    }
    
    // which days already have reminders scheduled?
    func getDaysAlreadyScheduled(_ notificationRequests : [UNNotificationRequest]) -> Set<Int> {
        let calendar = Calendar.current
        
        var daysAlreadyScheduled = Set<Int>()
        
        let today = self.getDateAtMidDay(Date())
        
        for item in notificationRequests {
            if let intervalTrigger = item.trigger as? UNTimeIntervalNotificationTrigger {
                let triggerDate = self.getDateAtMidDay(intervalTrigger.nextTriggerDate()!)
                let components = calendar.dateComponents([.day], from: today, to: triggerDate)
                let dayNum = components.day!
                daysAlreadyScheduled.insert(dayNum)
            }
        }
        
        return daysAlreadyScheduled
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
    
    func scheduleTestReminder() {
        // create a reminder five seconds from now
        let testReminder = rjReminder()
        testReminder.time = rjCommon.unixTimestamp() + 5;

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
    
    func getCurrentScheduleReadable(completion: @escaping (String) -> Void) {
        notificationCenter.getPendingNotificationRequests { (notifications) in
            var scheduleStr = ""
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "MMM d, h:mm:ss a"

            for item in notifications {
                if let intervalTrigger = item.trigger as? UNTimeIntervalNotificationTrigger {
                    scheduleStr += dateFormatter.string(from: intervalTrigger.nextTriggerDate()!) + "\n"
                }
            }
            
            completion(scheduleStr)
        }
    }
    
    func clearReminders() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
}
