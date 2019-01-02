//
//  rjMomentSummaryGraphViewModelTest.swift
//  randomjournalTests
//
//  Created by Tom Plaskon on 2018-12-17.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import XCTest
@testable import Presently

class rjMomentSummaryGraphViewModelTest: XCTestCase {

    var model: rjMomentSummaryGraphViewModel? = nil
    
    override func setUp() {
        // create our date range
        let Dec15BOD = Date(timeIntervalSince1970: 1544850000)
        let Dec17EOD = Date(timeIntervalSince1970: 1545109199)
        
        // inject the DateFormatter dependency
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.init(identifier: .gregorian)
        dateFormatter.locale = Locale.init(identifier: "en_CA")
        
        var model = rjMomentSummaryGraphViewModel(startDate: Dec15BOD, endDate: Dec17EOD, dateFormatter: dateFormatter)
        
        var moments = [rjMomentEntityModel]()
        
        /*
            Create moments that result in the following situation
         
            Day             Dec 15  Dec 16  Dec 17
            Num moments     1       2       3
            Word count      1       3       6
            Ratio           1/6     3/6     6/6
            Day of week     Sat     Sun     Mon
        */
        
        // one moment on Dec 15
        var moment = rjMomentEntityModel(id: "a", when: Dec15BOD.addingTimeInterval(1), details: "1")
        moments.append(moment)
        
        // two moments on Dec 16
        let Dec16BOD = Date(timeIntervalSince1970: 1544936400)
        moment = rjMomentEntityModel(id: "b", when: Dec16BOD.addingTimeInterval(1), details: "1")
        moments.append(moment)

        moment = rjMomentEntityModel(id: "c", when: Dec16BOD.addingTimeInterval(2), details: "one two")
        moments.append(moment)
        
        // three moments on Dec 17
        let Dec17BOD = Date(timeIntervalSince1970: 1545022800)
        moment = rjMomentEntityModel(id: "d", when: Dec17BOD.addingTimeInterval(1), details: "1")
        moments.append(moment)
        
        moment = rjMomentEntityModel(id: "e", when: Dec17BOD.addingTimeInterval(2), details: "one two")
        moments.append(moment)

        moment = rjMomentEntityModel(id: "f", when: Dec17BOD.addingTimeInterval(3), details: "one two. three.")
        moments.append(moment)
        
        model.add(moments: moments)
        
        self.model = model

    }

    func testColumnNames() {
        XCTAssertEqual(model?.columnNames, ["S", "S", "M"])
    }
    
    func testDataValues() {
        XCTAssertEqual(model?.dataValues, [1, 3, 6])
    }
    
    func testMaxValue() {
        XCTAssertEqual(model?.maxValue, 6)
    }

    func testMinValue() {
        XCTAssertEqual(model?.minValue, 1)
    }

    func testRatioValues() {
        XCTAssertEqual(model?.ratioValues, [1.0/6.0, 3.0/6.0, 6.0/6.0])
    }
}
