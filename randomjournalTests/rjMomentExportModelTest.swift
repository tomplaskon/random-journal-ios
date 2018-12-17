//
//  rjMomentExportModelTest.swift
//  randomjournalTests
//
//  Created by Tom Plaskon on 2018-12-17.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import XCTest

@testable import randomjournal

class rjMomentExportModelTest: XCTestCase {

    func testInit() {
        let entityModel = rjMomentEntityModel(
            id: "123abc",
            when: Date(timeIntervalSince1970: 1545086993),
            details: "Test Details"
        )

        let exportModel = rjMomentExportModel(entityModel)
        XCTAssertEqual(exportModel.id, "123abc")
        XCTAssertEqual(exportModel.when.data, "1545086993")
        XCTAssertEqual(exportModel.details, "Test Details")
    }
    
    func testInitWithValues() {
        let exportModel = rjMomentExportModel(
            id: "123abc",
            when: Date(timeIntervalSince1970: 1545086993),
            details: "Test Details"
        )
        XCTAssertEqual(exportModel.id, "123abc")
        XCTAssertEqual(exportModel.when.data, "1545086993")
        XCTAssertEqual(exportModel.details, "Test Details")
    }
    
    func testEntityModel() {
        let entityModel = rjMomentEntityModel(
            id: "123abc",
            when: Date(timeIntervalSince1970: 1545086993),
            details: "Test Details"
        )
        
        let exportModel = rjMomentExportModel(entityModel)
        XCTAssertEqual(exportModel.entityModel, entityModel)
    }

}
