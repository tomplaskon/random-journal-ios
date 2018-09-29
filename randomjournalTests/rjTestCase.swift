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
    func generateTestMoment() -> rjMoment {
        let moment = rjMoment();
        
        moment.details = "Test details " + String(rjCommon.unixTimestampMilliseconds())
        moment.when = rjCommon.unixTimestamp()
        
        return moment;
    }
    
    func assertMomentsEqual(_ moment1:rjMoment, _ moment2:rjMoment) {
        XCTAssertEqual(moment2.momentId, moment1.momentId)
        XCTAssertEqual(moment2.details, moment1.details);
        XCTAssertEqual(moment2.when, moment1.when);
    }
}
