//
//  DateExtensions.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-14.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

extension Date {
    func numDays(since endDate: Date) -> Int {
        return rjCommon.getNumDaysBetween(from: self, to: endDate)
    }
    
    func with(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    var intValue: Int {
        return Int(self.timeIntervalSince1970)
    }
    
    var year: Int {
        return getYear()
    }
    
    func getYear(calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(.year, from: self)
    }
}
