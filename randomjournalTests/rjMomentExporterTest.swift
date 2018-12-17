//
//  rjMomentExporterTest.swift
//  randomjournalTests
//
//  Created by Tom Plaskon on 2018-10-19.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import XCTest
@testable import randomjournal

class rjMomentExporterTest: XCTestCase {
    let headerLine = "ID|WHEN_TIMESTAMP|WHEN_READABLE|MOMENT_DETAILS"
    
    func testGetCSVContent_empty() {
        let exporter = rjMomentExporter()
        
        let noMoments = [rjMomentExportModel]()
        let export = exporter.getCSVContent(noMoments)
        
        XCTAssertEqual(export, headerLine)
    }
    
    func testGetCSVContent_oneMoment() {
        let expectedExport = """
        \(headerLine)
        113716F8-7252-4D17-BA47-703456BDA686|1539887921|2018-10-18 14:38:41|Hello World!
        """
        
        let moment = rjMomentExportModel(
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
        113716F8-7252-4D17-BA47-703456BDA686|1539887921|2018-10-18 14:38:41|Hello World!
        """
        
        let moment = rjMomentExportModel(
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
        113716F8-7252-4D17-BA47-703456BDA686|1539887921|2018-10-18 14:38:41|Hello World!
        113716F8-7252-4D17-BA47-703456BDA687|1539887981|2018-10-18 14:39:41|Hello World 2!
        """
        
        var moments = [rjMomentExportModel]()
        
        var moment = rjMomentExportModel(
            id: "113716F8-7252-4D17-BA47-703456BDA686",
            when: Date(timeIntervalSince1970: 1539887921),
            details: "Hello World!"
        )
        moments.append(moment)

        moment = rjMomentExportModel(
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
        113716F8-7252-4D17-BA47-703456BDA686|1539887921|2018-10-18 14:38:41|Hello World!\\nHello World Again!
        113716F8-7252-4D17-BA47-703456BDA687|1539887981|2018-10-18 14:39:41|Hello World 2!
        """
        
        var moments = [rjMomentExportModel]()
        
        var moment = rjMomentExportModel(
            id: "113716F8-7252-4D17-BA47-703456BDA686",
            when: Date(timeIntervalSince1970: 1539887921),
            details: "Hello World!\nHello World Again!"
        )
        moments.append(moment)
        
        moment = rjMomentExportModel(
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
