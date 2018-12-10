//
//  rjMomentMgrTest.swift
//  randomjournalTests
//
//  Created by Tom Plaskon on 2018-09-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import XCTest
@testable import randomjournal

class rjMomentMgrTest: rjTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddMoment() {
        let momentMgr = rjMomentMgr();
        let moment = generateTestMoment();
        
        // create moment
        let momentId = momentMgr.addMoment(moment)
        
        // verify it has a valid momentId
        XCTAssertNotEqual(momentId, "")
        XCTAssertNotEqual(moment.momentId, "")
        XCTAssertEqual(moment.momentId, momentId)
        
        // save moment
        momentMgr.addMoment(moment)
        
        // load the moment from the persistence layer
        if let moment2 = momentMgr.getMomentById(momentId) {
            // verify the moments have the same data
            assertMomentsEqual(moment, moment2)
        } else {
            XCTFail("No moment returned by getMomentById")
        }
    }
    
    func testAllMoments() {
        let momentMgr = rjMomentMgr();
        let moment = generateTestMoment();

        // get the current number of moments we have stored
        let currentNumMoments = momentMgr.allMoments().count
        
        // create a new moment
        momentMgr.addMoment(moment)
        
        XCTAssertEqual(currentNumMoments+1, momentMgr.allMoments().count)
        
    }
    
}
