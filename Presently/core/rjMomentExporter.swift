//
//  rjMomentExporter.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-19.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjMomentExporter {
    func getCSVContent(_ moments : [rjMoment]) -> String {
        var csvContent = ""
        

        for moment in moments {
            let lineElements = [
                moment.momentId,
                String(moment.when),
                moment.whenReadableLong(),
                cleanDetails(moment.details)
            ]
            csvContent += lineElements.joined(separator: "|") + "\n"
        }
        
        return csvContent
    }
    
    func getHeaderLine() -> String {
        return [
            "
        ].joined(separator: "|") + "\n"
    }
    
    func getCSVFileName() -> String {
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        let dateString = dateFormatter.string(from: date)
        
        return "random_journal_export_" + dateString + ".csv"
    }
    
    func getCSVFileURL(_ fileName: String) -> URL? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return dir.appendingPathComponent(fileName)
        }
        
        return nil;
    }
    
    func writeCSVFile(_ fileURL: URL, content: String) -> Bool {
        do {
            try content.write(to: fileURL, atomically: false, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }
    
    func exportMomentsToFile() -> URL? {
        let moments = rjMomentMgr().allMoments()
        let content = getCSVContent(moments)
        if let fileURL = getCSVFileURL(getCSVFileName()) {
            if (writeCSVFile(fileURL, content: content)) {
                return fileURL
            }
        }
        
        return nil
    }
    
    func cleanDetails(_ details : String) -> String {
            let cleanDetails = details.replacingOccurrences(of: "\n", with: "\\n")
        
            return cleanDetails
    }
}
