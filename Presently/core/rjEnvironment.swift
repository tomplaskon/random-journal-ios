//
//  rjEnvironment.swift
//  Presently
//
//  Created by Tom Plaskon on 2019-01-03.
//  Copyright © 2019 Tom Plaskon. All rights reserved.
//

import Foundation

class rjEnvironment {
    static var isTestBuild: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
}
