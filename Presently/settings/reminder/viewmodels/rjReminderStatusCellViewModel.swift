//
//  rjRemindersEnabledCellViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-11-22.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import Bond
import UserNotifications

class rjReminderStatusCellViewModel {
    let title: String
    let remindersEnabled: Observable<Bool>
    let errorMsg = Observable<String>("")
    
    init(title: String, remindersEnabled: Bool) {
        self.title = title
        self.remindersEnabled = Observable(remindersEnabled)
    }
    
    func start() {
        updateState()
    }
    
    func updateState() {
        rjReminderScheduler.shared.areNotificationsEnabled { [weak self] enabled in
            self?.remindersEnabled.value = enabled
        }
    }
    
    func switchPressed() {
        errorMsg.value = ""
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { [weak self] (granted, error) in
            if (!granted) {
                self?.errorMsg.value = "To use reminders you need to enable notifications in Settings for Random Journal"
                self?.updateState()
                return
            }
            
            let scheduler = rjReminderScheduler.shared
            let settings = rjAppSettings.shared
            
            if (rjAppSettings.shared.areRemindersEnabled()) {
                // toggling reminders off
                settings.setRemindersStatus(enabled: false)
                scheduler.clearReminders()
            } else {
                // toggling reminders on
                settings.setRemindersStatus(enabled: true)
                scheduler.updateReminders()
            }
            
            self?.remindersEnabled.value = rjAppSettings.shared.areRemindersEnabled()
        }
    }
}
