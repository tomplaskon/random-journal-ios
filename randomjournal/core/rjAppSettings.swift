//
//  rjAppSettings.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-08.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjAppSettings {
    let remindersEnabledDefaultsKey = "rjRemindersEnabled"
    let tutorialShownDefaultsKey = "rjTutorialShown"
    let reminderStartTimeOffsetDefaultsKey = "rjReminderStartTimeOffset"
    let reminderEndTimeOffsetDefaultsKey = "rjReminderEndTimeOffset"

    var shuffleMoments = false
    
    static let shared = rjAppSettings()
    
    private init() {
        
    }
    
    func getNumDailyAlerts() -> Int {
        return 1
    }
    
    // seconds from beginning of day
    func getReminderStartTimeOffset() -> Int {
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: reminderStartTimeOffsetDefaultsKey) == nil {
            return 9*60*60
        }
        
        return defaults.integer(forKey: reminderStartTimeOffsetDefaultsKey)
    }
    
    func setReminderStartTimeOffset(_ offset: Int) {
        let defaults = UserDefaults.standard
        
        defaults.set(offset, forKey: reminderStartTimeOffsetDefaultsKey)
    }
    
    // seconds from beginning of day
    func getReminderEndTimeOffset() -> Int {
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: reminderEndTimeOffsetDefaultsKey) == nil {
            return 22*60*60
        }
        
        return defaults.integer(forKey: reminderEndTimeOffsetDefaultsKey)
    }
    
    func setReminderEndTimeOffset(_ offset: Int) {
        let defaults = UserDefaults.standard
        defaults.set(offset, forKey: reminderEndTimeOffsetDefaultsKey)
    }
    
    func areRemindersEnabled() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: remindersEnabledDefaultsKey)
    }
    
    func setRemindersStatus(enabled : Bool) {
        let defaults = UserDefaults.standard
        defaults.set(enabled, forKey: remindersEnabledDefaultsKey)
    }
    
    func shouldShowTutorial() -> Bool {
        return !UserDefaults.standard.bool(forKey: tutorialShownDefaultsKey)
    }
    
    func setTutorialComplete() {
        UserDefaults.standard.set(true, forKey: tutorialShownDefaultsKey)
    }
}
