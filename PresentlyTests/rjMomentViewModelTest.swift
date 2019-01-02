//
//  rjMomentViewModelTest.swift
//  randomjournalTests
//
//  Created by Tom Plaskon on 2018-12-17.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import XCTest

@testable import Presently

class rjMomentViewModelTest: XCTestCase {
    func testInit() {
        let model = rjMomentViewModel(id: "id", when: Date(timeIntervalSince1970: 1545058475), details: "details")
        
        XCTAssertEqual(model.id, "id")
        XCTAssertEqual(model.when.intValue, 1545058475)
        XCTAssertEqual(model.details, "details")
    }
    
    func testInitWithModel() {
        let dataModel = rjMomentEntityModel(
            id: "68b696d7-320b-4402-a412-d9cee10fc6a3",
            when: Date(timeIntervalSince1970: 1545058476),
            details: "Some details"
        )
        let model = rjMomentViewModel(dataModel)
        
        XCTAssertEqual(model.id, "68b696d7-320b-4402-a412-d9cee10fc6a3")
        XCTAssertEqual(model.when.intValue, 1545058476)
        XCTAssertEqual(model.details, "Some details")
    }
}
