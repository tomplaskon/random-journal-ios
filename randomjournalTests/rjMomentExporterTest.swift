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
        
        let noMoments = [rjMomentModel]()
        let export = exporter.getCSVContent(noMoments)
        
        XCTAssertEqual(export, headerLine)
    }
    
    func testGetCSVContent_oneMoment() {
        let expectedExport = """
        \(headerLine)
        113716F8-7252-4D17-BA47-703456BDA686|1539887921|Oct 18 2018 02:38 PM|Hello World!
        """
        
        let moment = rjMomentModel(
            id: "113716F8-7252-4D17-BA47-703456BDA686",
            when: Date(timeIntervalSince1970: 1539887921),
            details: "Hello World!"
        )
        
        let exporter = rjMomentExporter()
        let export = exporter.getCSVContent([moment])
        
        XCTAssertEqual(export, expectedExport)
    }
    
    func testGetCSVContent_momentWithDelim() {
        let expectedExport = """
        \(headerLine)
        113716F8-7252-4D17-BA47-703456BDA686|1539887921|Oct 18 2018 02:38 PM|Hello World!
        """
        
        let moment = rjMomentModel(
            id: "113716F8-7252-4D17-BA47-703456BDA686",
            when: Date(timeIntervalSince1970: 1539887921),
            details: "Hello|World!"
        )
        
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
        
        var moments = [rjMomentModel]()
        
        var moment = rjMomentModel(
            id: "113716F8-7252-4D17-BA47-703456BDA686",
            when: Date(timeIntervalSince1970: 1539887921),
            details: "Hello World!"
        )
        moments.append(moment)

        moment = rjMomentModel(
            id: "113716F8-7252-4D17-BA47-703456BDA687",
            when: Date(timeIntervalSince1970: 1539887981),
            details: "Hello World 2!"
        )
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
        
        var moments = [rjMomentModel]()
        
        var moment = rjMomentModel(
            id: "113716F8-7252-4D17-BA47-703456BDA686",
            when: Date(timeIntervalSince1970: 1539887921),
            details: "Hello World!\nHello World Again!"
        )
        moments.append(moment)
        
        moment = rjMomentModel(
            id: "113716F8-7252-4D17-BA47-703456BDA687",
            when: Date(timeIntervalSince1970: 1539887981),
            details: "Hello World 2!"
        )
        moments.append(moment)
        
        let exporter = rjMomentExporter()
        let export = exporter.getCSVContent(moments)
        
        XCTAssertEqual(export, expectedExport)
    }
    
}
