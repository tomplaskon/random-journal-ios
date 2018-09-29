//
//  rjReminder.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-08.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjReminder {
    var time = 0;
    
    func getTimeIntervalFromNow() -> Int {
        return time - rjCommon.unixTimestamp()
    }
}
