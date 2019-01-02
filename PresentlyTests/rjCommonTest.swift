//
//  rjCommonTest.swift
//  randomjournalTests
//
//  Created by Tom Plaskon on 2018-10-10.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import XCTest
@testable import Presently

class rjCommonTest: XCTestCase {
    func testGetDateAtBeginningOfDay() {
        let date = Date(timeIntervalSince1970: 1539194970)
        let dateAtBeginningOfDay = rjCommon.getDateAtBeginningOfDay(date)
        
        XCTAssertEqual(dateAtBeginningOfDay.timeIntervalSince1970, 1539144000)
    }
}
