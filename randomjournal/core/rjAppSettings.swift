//
//  rjAppSettings.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-08.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjAppSettings: NSObject {
    let RemindersEnabledDefaultsKey = "rjRemindersEnabled"
    
    func getNumDailyAlerts() -> Int {
        return 1;
    }
    
    // seconds from beginning of day
    func getReminderStartTime() -> Int {
        return 9*60*60;
    }
    
    // secons from beginning of day
    func getReminderEndTime() -> Int {
        return 22*60*60;
    }
    
    func areRemindersEnabled() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: RemindersEnabledDefaultsKey)
    }
    
    func setRemindersStatus(enabled : Bool) {
        let defaults = UserDefaults.standard
        defaults.set(enabled, forKey: RemindersEnabledDefaultsKey)
    }
}
