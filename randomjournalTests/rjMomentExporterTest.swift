//
//  rjMomentExporterTest.swift
//  randomjournalTests
//
//  Created by Tom Plaskon on 2018-10-19.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import XCTest
@testable import randomjournal

class rjMomentExporterTest: rjTestCase {
    let headerLine = "ID|WHEN_TIMESTAMP|WHEN_READABLE|MOMENT_DETAILS"
    
    func testGetCSVContent_empty() {
        let exporter = rjMomentExporter()
        
        let noMoments = [rjMoment]()
        let export = exporter.getCSVContent(noMoments)
        
        XCTAssertEqual(export, headerLine)
    }
    
    func testGetCSVContent_oneMoment() {
        let expectedExport = """
        \(headerLine)
        113716F8-7252-4D17-BA47-703456BDA686|1539887921|Oct 18 2018 02:38 PM|Hello World!
        """
        
        let moment = rjMoment()
        moment.when = 1539887921
        moment.momentId = "113716F8-7252-4D17-BA47-703456BDA686"
        moment.details = "Hello World!"
        
        let exporter = rjMomentExporter()
        let export = exporter.getCSVContent([moment])
        
        XCTAssertEqual(export, expectedExport)
    }
    
    func testGetCSVContent_momentWithDelim() {
        let expectedExport = """
        \(headerLine)
        113716F8-7252-4D17-BA47-703456BDA686|1539887921|Oct 18 2018 02:38 PM|Hello World!
        """
        
        let moment = rjMoment()
        moment.when = 1539887921
        moment.momentId = "113716F8-7252-4D17-BA47-703456BDA686"
        moment.details = "Hello|World!"
        
        let exporter = rjMomentExporter()
        let export = exporter.getCSVContent([moment])
        
        XCTAssertEqual(export, expectedExport)
    }
    
    func testGetCSVContent_twoMoments() {
        let expectedExport = """
        \(headerLine)
        113716F8-7252-4D17-BA47-703456BDA686|1539887921|Oct 18 2018 02:38 PM|Hello World!
        113716F8-7252-4D17-BA47-703456BDA687|1539887981|Oct 18 2018 02:39 PM|Hello World 2!
        """
        
        var moments = [rjMoment]()
        
        var moment = rjMoment()
        moment.when = 1539887921
        moment.momentId = "113716F8-7252-4D17-BA47-703456BDA686"
        moment.details = "Hello World!"
        moments.append(moment)

        moment = rjMoment()
        moment.when = 1539887981
        moment.momentId = "113716F8-7252-4D17-BA47-703456BDA687"
        moment.details = "Hello World 2!"
        moments.append(moment)
        
        let exporter = rjMomentExporter()
        let export = exporter.getCSVContent(moments)
        
        XCTAssertEqual(export, expectedExport)
    }
    
    func testGetCSVContent_momentWithNewLineInDetails() {
        let expectedExport = """
        \(headerLine)
        113716F8-7252-4D17-BA47-703456BDA686|1539887921|Oct 18 2018 02:38 PM|Hello World!\\nHello World Again!
        113716F8-7252-4D17-BA47-703456BDA687|1539887981|Oct 18 2018 02:39 PM|Hello World 2!
        """
        
        var moments = [rjMoment]()
        
        var moment = rjMoment()
        moment.when = 1539887921
        moment.momentId = "113716F8-7252-4D17-BA47-703456BDA686"
        moment.details = "Hello World!\nHello World Again!"
        moments.append(moment)
        
        moment = rjMoment()
        moment.when = 1539887981
        moment.momentId = "113716F8-7252-4D17-BA47-703456BDA687"
        moment.details = "Hello World 2!"
        moments.append(moment)
        
        let exporter = rjMomentExporter()
        let export = exporter.getCSVContent(moments)
        
        XCTAssertEqual(export, expectedExport)
    }
    
}
