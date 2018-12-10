//
//  rjTestCase.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import XCTest
@testable import randomjournal

class rjTestCase: XCTestCase {
    func generateTestMoment() -> rjMomentModel {
        let momentMgr = rjMomentMgr()
        let details = "Test details " + String(rjCommon.unixTimestampMilliseconds())
        let when = Date()

        let momentId = momentMgr.addMoment(when: when, details: details)

        return momentMgr.getMomentById(momentId)!
    }
}
