//
//  rjCommon.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

class rjCommon {
    static let commonButtonReuseId = "commonbutton"
    static let commonTitleReuseId = "commontitle"
    static let commonSpacerReuseId = "commonspacer"

    static func unixTimestamp() -> Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    static func unixTimestampMilliseconds() -> TimeInterval {
        return Date().timeIntervalSince1970
    }

    static func unixTimestampAtBeginningOfToday() -> Int {
        let now = Date()
        let beginningOfDay = self.getDateAtBeginningOfDay(now)
        return Int(beginningOfDay.timeIntervalSince1970)
    }
    
    static func getDateAtBeginningOfDay(_ date: Date, calendar: Calendar = Calendar.current) -> Date {
        let beginningOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date)
        return beginningOfDay!
    }

    // return a Date on the same day with the time set to noon
    static func getDateAtMidDay(_ date: Date, calendar: Calendar = Calendar.current) -> Date {
        return calendar.date(bySettingHour: 12, minute: 00, second: 00, of: calendar.startOfDay(for: date))!
    }
    
    static func getDateAtEndOfDay(_ date: Date, calendar: Calendar = Calendar.current) -> Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
    }

    
    static func getRandomInt(from : Int, to : Int) -> Int {
        return Int(arc4random_uniform(UInt32(to-from)) + UInt32(from))
    }
    
    static func getDate(offset: Int) -> Date {
        let beginningOfDay = getDateAtBeginningOfDay(Date())

        let calendar = Calendar.current
        var dateComp = DateComponents()
        dateComp.second = offset
        let date = calendar.date(byAdding:dateComp, to: beginningOfDay)
        
        return date!
    }
    
    static func getOffset(date: Date) -> Int {
        let beginningOfDay = getDateAtBeginningOfDay(date)
        return Int(date.timeIntervalSince1970 - beginningOfDay.timeIntervalSince1970)
    }
    
    static func getReadableTimeOffset(_ time : Int) -> String {
        let calendar = Calendar.current
        var date = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        date = calendar.date(byAdding: .second, value: time, to: date)!
        
        return date.with(format: "h:mm a")
    }
    
    static func getReadableDateLong(_ date: Date, dateFormatter: DateFormatter = DateFormatter()) -> String {
        return date.with(format: "MMM d, YYYY @ h:mm a", dateFormatter: dateFormatter) // Jan 23, 2017 @ 1:23 PM
    }
    
    static func getNumDaysBetween(from: Date, to: Date, calendar: Calendar = Calendar.current) -> Int {
        let fromAtNoon = self.getDateAtMidDay(from)
        let toAtNoon = self.getDateAtMidDay(to)
        let components = calendar.dateComponents([.day], from: fromAtNoon, to: toAtNoon)
        return components.day!
    }
    
    static func add(days: Int, to date: Date) -> Date {
        return date.addingTimeInterval(TimeInterval(days*86400))
    }
    
    static func subtract(days: Int, from date: Date) -> Date {
        return date.addingTimeInterval(TimeInterval(days * 86400 * -1))
    }
}
