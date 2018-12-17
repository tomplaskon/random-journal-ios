//
//  rjMomentEntityModelTest.swift
//  randomjournalTests
//
//  Created by Tom Plaskon on 2018-12-17.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import XCTest

@testable import randomjournal

class rjMomentEntityModelTest: XCTestCase {
    func testInitWithPersistenceModel() {
        let persistenceModel = rjMomentPersistenceModel(
            momentId: "123abc",
            when: 1545086993,
            details: "Test details"
        )
        
        let entityModel = rjMomentEntityModel(persistenceModel)
        XCTAssertEqual(entityModel.id, "123abc")
        XCTAssertEqual(entityModel.when, Date(timeIntervalSince1970: 1545086993))
        XCTAssertEqual(entityModel.details, "Test details")
    }
    
    func testInitWithValues() {
        let entityModel = rjMomentEntityModel(
            id: "123abc",
            when: Date(timeIntervalSince1970: 1545086993),
            details: "Test Details"
        )
        XCTAssertEqual(entityModel.id, "123abc")
        XCTAssertEqual(entityModel.when, Date(timeIntervalSince1970: 1545086993))
        XCTAssertEqual(entityModel.details, "Test Details")
    }
}
