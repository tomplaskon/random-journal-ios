//
//  rjMomentMgrTest.swift
//  randomjournalTests
//
//  Created by Tom Plaskon on 2018-09-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import XCTest
@testable import Presently

class rjMomentViewModelRepositoryTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddMoment() {
        let momentMgr = rjMomentViewModelRepository.shared
        
        // create moment
        let moment = rjMomentViewModel(generateTestMoment());

        // verify it has a valid momentId
        XCTAssertNotEqual(moment.id, "")
        
        // load the moment from the persistence layer
        if let moment2 = momentMgr.getById(moment.id) {
            // verify the moments have the same data
            XCTAssertEqual(moment, moment2)
        } else {
            XCTFail("No moment returned by getById")
        }
    }
    
    func testAllMoments() {
        let momentMgr = rjMomentViewModelRepository.shared

        // get the current number of moments we have stored
        let currentNumMoments = momentMgr.all().count
        
        // create a new moment
        let _ = generateTestMoment();

        XCTAssertEqual(currentNumMoments+1, momentMgr.all().count)
        
    }
    
}
