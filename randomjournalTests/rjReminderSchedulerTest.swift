//
//  rjReminderSchedulerTest.swift
//  randomjournalTests
//
//  Created by Tom Plaskon on 2018-10-10.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import XCTest
@testable import randomjournal

class rjReminderSchedulerTest: rjTestCase {
    func testGetDateAtMidDay() {
        let scheduler = rjReminderScheduler.shared
        
        let targetTimestampAtNoon = TimeInterval(1539532800)
        
        let date2pm = Date(timeIntervalSince1970: 1539540000)
        var dateNoon = scheduler.getDateAtMidDay(date2pm)
        XCTAssertEqual(dateNoon.timeIntervalSince1970, targetTimestampAtNoon)
        
        let date11am = Date(timeIntervalSince1970: 1539529200)
        dateNoon = scheduler.getDateAtMidDay(date11am)
        XCTAssertEqual(dateNoon.timeIntervalSince1970, targetTimestampAtNoon)
        
        let firstSecondOfDay = Date(timeIntervalSince1970: 1539489600)
        dateNoon = scheduler.getDateAtMidDay(firstSecondOfDay)
        XCTAssertEqual(dateNoon.timeIntervalSince1970, targetTimestampAtNoon)
        
        let lastSecondOfDay = Date(timeIntervalSince1970: 1539575999)
        dateNoon = scheduler.getDateAtMidDay(lastSecondOfDay)
        XCTAssertEqual(dateNoon.timeIntervalSince1970, targetTimestampAtNoon)
        
        let dateNoon2 = Date(timeIntervalSince1970: 1539532800)
        dateNoon = scheduler.getDateAtMidDay(dateNoon2)
        XCTAssertEqual(dateNoon.timeIntervalSince1970, targetTimestampAtNoon)
    }
    
    func testGetNumDays() {
        let scheduler = rjReminderScheduler.shared
        
        // less than 24 hours difference
        let dateAfternoon = Date(timeIntervalSince1970: 1539575999)
        let nextMorning = Date(timeIntervalSince1970: 1539576000)
        XCTAssertEqual(scheduler.getNumDays(from: dateAfternoon, to: nextMorning), 1)
        
        // 47:59:59 interval apart
        let firstSecondDayOne = Date(timeIntervalSince1970: 1539489600)
        let lastSecondDayTwo = Date(timeIntervalSince1970: 1539662399)
        XCTAssertEqual(scheduler.getNumDays(from: firstSecondDayOne, to: lastSecondDayTwo), 1)
        
        // more than 7 days
        let dayOne = Date(timeIntervalSince1970: 1539489600)
        let dayEight = Date(timeIntervalSince1970: 1540267199)
        XCTAssertEqual(scheduler.getNumDays(from: dayOne, to: dayEight), 8)
        
        // over month end
        let lastDayOfMonth = Date(timeIntervalSince1970: 1541044799)
        let firstDayOfNextMonth = Date(timeIntervalSince1970: 1541131199)
        XCTAssertEqual(scheduler.getNumDays(from: lastDayOfMonth, to: firstDayOfNextMonth), 1)
        
        // 0 days apart
        let lastSecondOfDay = Date(timeIntervalSince1970: 1541131199)
        let secondLastSecondOfDay = Date(timeIntervalSince1970: 1541131198)
        XCTAssertEqual(scheduler.getNumDays(from: lastSecondOfDay, to: secondLastSecondOfDay), 0)
        
        // negative one days apart
        XCTAssertEqual(scheduler.getNumDays(from: lastSecondDayTwo, to: firstSecondDayOne), -1)
    }
}
