//
//  rjExportFileFormat.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-19.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjExportFileFormat: NSObject {
    
    static let fieldDelimiter = "|"
    static let lineDelimiter = "\n"
    
    static func getFieldNames() -> [String] {
        return ["ID", "WHEN_TIMESTAMP", "WHEN_READABLE", "MOMENT_DETAILS"]
    }
    
    static func getHeaderLine() -> String {
        return self.getFieldNames().joined(separator: "|")
    }
}
