//
//  rjMomentImporter.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-19.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

enum rjMomentImporterError: Error {
    case invalidHeader
}

class rjMomentImporterResults {
    var numMomentsImported = 0
    var numMomentsSkipped = 0
}

class rjMomentImporter {
    
    func processMoments(_ content : String, onSuccess closure: (rjMomentViewModel) -> (Bool)) throws -> rjMomentImporterResults {
        let cleanContent = cleanLineEndings(content)
        let lines = cleanContent.components(separatedBy: rjExportFileFormat.lineDelimiter)
        
        var checkedHeaderLine = false
        let importResults = rjMomentImporterResults()
        
        for line in lines {
            if (checkedHeaderLine) {
                // we have already checked the header line, this is a content line
                if let moment = getMomentFromLine(line) {
                    // valid line, pass to closure for processing
                    if closure(moment) {
                        // closure processing successful
                        importResults.numMomentsImported += 1
                    } else {
                        // closure processing failed
                        importResults.numMomentsSkipped += 1
                    }
                } else {
                    // invalid line
                    importResults.numMomentsSkipped += 1
                }
                
            } else {
                if hasValidHeaderFormat(line) {
                    // valid improt format
                    checkedHeaderLine = true
                    continue
                } else {
                    // invalid import format
                    throw rjMomentImporterError.invalidHeader
                }
            }
        }
        
        return importResults
    }
    
    func hasValidHeaderFormat(_ headerLine : String) -> Bool {
        let fields = headerLine.components(separatedBy: rjExportFileFormat.fieldDelimiter)
        
        // do we have the right number of fields?
        if fields.count != 4 {
            return false
        }
        
        // do we have the right field names in the right order?
        let expectedFields = rjExportFileFormat.getFieldNames()
        if (fields != expectedFields) {
            return false
        }
        
        return true
    }
    
    func cleanLineEndings(_ content : String) -> String {
        var cleanContent = content.replacingOccurrences(of: "\n\r", with: "\n")
        cleanContent = cleanContent.replacingOccurrences(of: "\r", with: "\n")
        return cleanContent
    }
    
    func getMomentFromLine(_ line : String) -> rjMomentViewModel? {
        // validate fields
        let fields = line.components(separatedBy: rjExportFileFormat.fieldDelimiter)
        if fields.count != 4 {
            return nil
        }
        
        let id = fields[0].trimmingCharacters(in: .whitespaces)
        if !isValidMomentId(id) {
            return nil
        }
        
        guard let whenInt = Int(fields[1].trimmingCharacters(in: .whitespaces)), let whenTime = TimeInterval(exactly: whenInt)  else {
            return nil
        }
        let when = Date(timeIntervalSince1970: whenTime)
        
        let details = self.cleanDescription(fields[3]).trimmingCharacters(in: .whitespaces)
        
        let moment = rjMomentViewModel(id: id, when: when, details: details)
        
        return moment
    }
    
    func isValidMomentId(_ momentId : String) -> Bool {
        return momentId.count == 36
    }
    
    func cleanDescription(_ description : String) -> String {
        var cleanDescription = description.replacingOccurrences(of: "\\n", with: "\n")
        cleanDescription = cleanDescription.trimmingCharacters(in: .whitespaces)
        
        if cleanDescription.hasPrefix("\"") && cleanDescription.hasSuffix("\"") {
            // the description is escaped
            let x = cleanDescription.index(cleanDescription.startIndex, offsetBy: 1)
            let y = cleanDescription.index(cleanDescription.endIndex, offsetBy: -1)
            cleanDescription = String(cleanDescription[x...y])
        }
        
        return cleanDescription
    }
    
    func importMoments(_ content : String) throws -> rjMomentImporterResults {
        let momentMgr = rjMomentMgr()
        
        let result = try self.processMoments(content) { moment in
            return momentMgr.importMoment(moment)
        }
        
        return result
    }
}
