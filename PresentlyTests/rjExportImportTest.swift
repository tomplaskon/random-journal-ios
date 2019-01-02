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
    func testImportAndExport_empty() {
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
    
    func testImportAndExport_twoMoments() {
        let exporter = rjMomentExporter()
        let importer = rjMomentImporter()
        
        var moments = [rjMoment]()
        
        
        
        let export = exporter.getCSVContent(moments)
        
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
}
