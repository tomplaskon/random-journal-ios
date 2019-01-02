//
//  rjExportCSVViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-03.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

struct rjCSVExportViewModel {
    let fileURL: URL
    let fileName: String
    let subject = "Presently Export"
    let body = "Here is your Presently export data. Enjoy!"
    let isBodyHTML = false
    let mimeType = "text/csv"
    let fileData: Data
}
