//
//  rjMomentWhenDateViewModel.swift
//  randomjournalTests
//
//  Created by Tom Plaskon on 2018-12-17.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import XCTest

@testable import randomjournal

class rjMomentWhenDateViewModelTest: rjTestCase {

    func testDate() {
        let when = rjMomentViewModel.rjMomentWhenDateViewModel(date: Date(timeIntervalSince1970: 1545061969))
        XCTAssertEqual(when.date, Date(timeIntervalSince1970: 1545061969))
    }

    func testLong() {
        let when = rjMomentViewModel.rjMomentWhenDateViewModel(date: Date(timeIntervalSince1970: 1545061969))
        XCTAssertEqual(when.long, "Dec 17, 2018 @ 10:52 AM")
    }
    
    func testExport() {
        let when = rjMomentViewModel.rjMomentWhenDateViewModel(date: Date(timeIntervalSince1970: 1545061969))
        XCTAssertEqual(when.export, "2018-12-17 10:52:49")
    }
    
    func testIntValue() {
        let when = rjMomentViewModel.rjMomentWhenDateViewModel(date: Date(timeIntervalSince1970: 1545061969))
        XCTAssertEqual(when.intValue, 1545061969)
    }

    func testContextualToday() {
        let when = rjMomentViewModel.rjMomentWhenDateViewModel(date: Date(timeIntervalSince1970: 1545061969))
        XCTAssertEqual(when.getContextualDate(relativeTo: Date(timeIntervalSince1970: 1545061980)), "Today @ 10:52 AM")
    }
    
    func testContextualYesterday() {
        let oneDay: Double = 60*60*24
        let when = rjMomentViewModel.rjMomentWhenDateViewModel(date: Date(timeIntervalSince1970: 1545061969-oneDay))
        XCTAssertEqual(when.getContextualDate(relativeTo: Date(timeIntervalSince1970: 1545061980)), "Yesterday @ 10:52 AM")
    }
    
    func testContextualThisWeek() {
        let twoDays: Double = 60*60*24 * 2
        let when = rjMomentViewModel.rjMomentWhenDateViewModel(date: Date(timeIntervalSince1970: 1545061969-twoDays))
        XCTAssertEqual(when.getContextualDate(relativeTo: Date(timeIntervalSince1970: 1545061980)), "Saturday @ 10:52 AM")
    }
    
    func testContextualEarlierThisYear() {
        let fortyDays: Double = 60*60*24 * 40
        let when = rjMomentViewModel.rjMomentWhenDateViewModel(date: Date(timeIntervalSince1970: 1545061969-fortyDays))
        XCTAssertEqual(when.getContextualDate(relativeTo: Date(timeIntervalSince1970: 1545061980)), "Wed, November 7 @ 10:52 AM")
    }
    
    func testContextualLastYear() {
        let oneYear: Double = 60*60*24 * 365
        let when = rjMomentViewModel.rjMomentWhenDateViewModel(date: Date(timeIntervalSince1970: 1545061969-oneYear))
        XCTAssertEqual(when.getContextualDate(relativeTo: Date(timeIntervalSince1970: 1545061980)), "Sun, Dec 17, 2017 @ 10AM")
    }
}
