//
//  rjCommon.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjCommon {
    static let hasSetDefaultsSettingsKey = "rjHasSetDefaultSettings"
    static let numDailyAlertsSettingsKey = "rjNumDailyAlerts"
    static let alertStartTimeSettingsKey = "rjAlertStartTime"
    static let alertEndTimeSettingsKey = "rjAlertEndTime"
    
    static func unixTimestamp() -> Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    static func unixTimestampMilliseconds() -> TimeInterval {
        return Date().timeIntervalSince1970
    }

    static func unixTimestampAtBeginningOfToday() -> Int {
        let now = Date()
        let calendar = Calendar.current
        let beginningOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: now)
        return Int(beginningOfDay!.timeIntervalSince1970)
    }
    
}
