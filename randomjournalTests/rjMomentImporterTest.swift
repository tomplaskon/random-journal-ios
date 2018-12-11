//
//  rjMomentImporterTest.swift
//  randomjournalTests
//
//  Created by Tom Plaskon on 2018-10-19.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import XCTest
@testable import randomjournal

class rjMomentImporterTest: rjTestCase {
    let headerLine = "ID|WHEN_TIMESTAMP|WHEN_READABLE|MOMENT_DETAILS"
    
    func testProcessMoments_empty() {
        let importer = rjMomentImporter()
        let export = ""
        
        do {
            let _ = try importer.processMoments(export) { moment in
                XCTFail("Closure should not have been called")
                return true
            }
        } catch (rjMomentImporterError.invalidHeader) {
            // success
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
    
    func testProcessMoments_headerOnly() {
        let importer = rjMomentImporter()
        let export = headerLine
        
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
    
    func testProcessMoments_twoValidMoments() {
        let export = """
        \(headerLine)
        113716F8-7252-4D17-BA47-703456BDA686|1539887921|Oct 18 2018 02:38 PM|Hello World!
        113716F8-7252-4D17-BA47-703456BDA687|1539887981|Oct 18 2018 02:39 PM|Hello World 2!
        """

        let importer = rjMomentImporter()
        var moments = [rjMomentViewModel]()
        
        do {
            let result = try importer.processMoments(export) { moment in
                moments.append(moment)
                return true
            }

            XCTAssertEqual(moments.count, 2)
            
            var moment = moments[0]
            XCTAssertEqual(moment.id, "113716F8-7252-4D17-BA47-703456BDA686")
            XCTAssertEqual(moment.when, Date(timeIntervalSince1970: 1539887921))
            XCTAssertEqual(moment.details, "Hello World!")

            moment = moments[1]
            XCTAssertEqual(moment.id, "113716F8-7252-4D17-BA47-703456BDA687")
            XCTAssertEqual(moment.when, Date(timeIntervalSince1970: 1539887981))
            XCTAssertEqual(moment.details, "Hello World 2!")
            
            XCTAssertEqual(result.numMomentsImported, 2)
            XCTAssertEqual(result.numMomentsSkipped, 0)
            
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
    
    func testProcessMoments_twoValidMomentsAndInvalidMoment() {
        let export = """
        \(headerLine)
        113716F8-7252-4D17-BA47-703456BDA686|1539887921|Oct 18 2018 02:38 PM|Hello World!
        113716F8-7252-4D17-BA47-703456BDA686|1539887921|Invalid Moment!
        113716F8-7252-4D17-BA47-703456BDA687|1539887981|Oct 18 2018 02:39 PM|Hello World 2!
        """
        
        let importer = rjMomentImporter()
        var moments = [rjMomentViewModel]()
        
        do {
            let result = try importer.processMoments(export) { moment in
                moments.append(moment)
                return true
            }
            
            XCTAssertEqual(moments.count, 2)
            
            var moment = moments[0]
            XCTAssertEqual(moment.id, "113716F8-7252-4D17-BA47-703456BDA686")
            XCTAssertEqual(moment.when, Date(timeIntervalSince1970: 1539887921))
            XCTAssertEqual(moment.details, "Hello World!")
            
            moment = moments[1]
            XCTAssertEqual(moment.id, "113716F8-7252-4D17-BA47-703456BDA687")
            XCTAssertEqual(moment.when, Date(timeIntervalSince1970: 1539887981))
            XCTAssertEqual(moment.details, "Hello World 2!")
            
            XCTAssertEqual(result.numMomentsImported, 2)
            XCTAssertEqual(result.numMomentsSkipped, 1)
            
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
    
    func testProcessMoments_twoValidMomentsWithNewLinesInDetails() {
        let export = """
        \(headerLine)
        113716F8-7252-4D17-BA47-703456BDA686|1539887921|Oct 18 2018 02:38 PM|Hello World!\\nHello World Again!
        113716F8-7252-4D17-BA47-703456BDA687|1539887981|Oct 18 2018 02:39 PM|Hello World 2!
        """
        
        let importer = rjMomentImporter()
        var moments = [rjMomentViewModel]()
        
        do {
            let result = try importer.processMoments(export) { moment in
                moments.append(moment)
                return true
            }
            
            XCTAssertEqual(moments.count, 2)
            
            var moment = moments[0]
            XCTAssertEqual(moment.id, "113716F8-7252-4D17-BA47-703456BDA686")
            XCTAssertEqual(moment.when, Date(timeIntervalSince1970: 1539887921))
            XCTAssertEqual(moment.details, "Hello World!\nHello World Again!")
            
            moment = moments[1]
            XCTAssertEqual(moment.id, "113716F8-7252-4D17-BA47-703456BDA687")
            XCTAssertEqual(moment.when, Date(timeIntervalSince1970: 1539887981))
            XCTAssertEqual(moment.details, "Hello World 2!")
            
            XCTAssertEqual(result.numMomentsImported, 2)
            XCTAssertEqual(result.numMomentsSkipped, 0)
            
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
    
    func testProcessMoments_validMomentsWithInvalidHeader() {
        let invalidHeaderLine = "ID|WHEN_TIMESTAMP|BLAH|MOMENT_DETAILS"
        let export = """
        \(invalidHeaderLine)
        113716F8-7252-4D17-BA47-703456BDA686|1539887921|Oct 18 2018 02:38 PM|Hello World!
        113716F8-7252-4D17-BA47-703456BDA687|1539887981|Oct 18 2018 02:39 PM|Hello World 2!
        """
        
        let importer = rjMomentImporter()
        
        do {
            let _ = try importer.processMoments(export) { moment in
                XCTFail("Closure should not have been called")
                return true
            }
        } catch (rjMomentImporterError.invalidHeader) {
            // success
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
    
    func testProcessMoments_validMomentsWithNoHeader() {
        let export = """
        113716F8-7252-4D17-BA47-703456BDA686|1539887921|Oct 18 2018 02:38 PM|Hello World!
        113716F8-7252-4D17-BA47-703456BDA687|1539887981|Oct 18 2018 02:39 PM|Hello World 2!
        """
        
        let importer = rjMomentImporter()
        
        do {
            let _ = try importer.processMoments(export) { moment in
                XCTFail("Closure should not have been called")
                return true
            }
        } catch (rjMomentImporterError.invalidHeader) {
            // success
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }
}
