//
//  rjExportImportTest.swift
//  randomjournalTests
//
//  Created by Tom Plaskon on 2018-10-19.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import XCTest
@testable import randomjournal

class rjMomentExportImportTest: rjTestCase {
    func testExportAndImport_empty() {
        let exporter = rjMomentExporter()
        let importer = rjMomentImporter()
        
        let noMoments = [rjMoment]()
        let export = exporter.getCSVContent(noMoments)
        
        do {
            let result = try importer.processMoments(export) { moment in
                XCTFail("Closure should not have been called")
                return true
            }
            
            XCTAssertEqual(result.numMomentsImported, 0)
            XCTAssertEqual(result.numMomentsSkipped, 0)
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
    
    func testExportAndImport_twoMoments() {
        let exporter = rjMomentExporter()
        let importer = rjMomentImporter()
        
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
        
        let export = exporter.getCSVContent(moments)
        
        var exportedMoments = [rjMoment]()
        
        do {
            let result = try importer.processMoments(export) { moment in
                exportedMoments.append(moment)
                return true
            }
            
            XCTAssertEqual(exportedMoments.count, 2)
            assertMomentsEqual(exportedMoments[0], moments[0])
            assertMomentsEqual(exportedMoments[1], moments[1])
            
            XCTAssertEqual(result.numMomentsImported, 2)
            XCTAssertEqual(result.numMomentsSkipped, 0)
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
}