//
//  StringExtensions.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-13.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

extension String {
    var wordCount: Int {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = self.components(separatedBy: chararacterSet)
        let words = components.filter { !$0.isEmpty }
        return words.count
    }
}
