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
        
        // create moment
        let moment = generateTestMoment();

        // verify it has a valid momentId
        XCTAssertNotEqual(moment.id, "")
        
        // load the moment from the persistence layer
        if let moment2 = momentMgr.getMomentById(moment.id) {
            // verify the moments have the same data
            XCTAssertEqual(moment, moment2)
        } else {
            XCTFail("No moment returned by getMomentById")
        }
    }
    
    func testAllMoments() {
        let momentMgr = rjMomentMgr();

        // get the current number of moments we have stored
        let currentNumMoments = momentMgr.allMoments().count
        
        // create a new moment
        let _ = generateTestMoment();

        XCTAssertEqual(currentNumMoments+1, momentMgr.allMoments().count)
        
    }
    
}
