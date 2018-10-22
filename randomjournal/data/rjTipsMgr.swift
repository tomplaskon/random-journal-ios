//
//  rjTipsMgr.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-22.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjTipsMgr {
    static func getTips() -> [String] {
        return [
            "Are there any prominent colors?",
            "Are there any unusual smells?",
            "Are you touching anything? What is its texture like?",
            "Is the weather affecting how you feel? Is it cold? Is it bright?",
            "Are there any imperfections? E.g., missing letters or scratches",
            "Slow down. Take a few breaths. Run your eyes over the seen. What do you see now?",
            "What are your surroundings?",
            "Are you experiencing any strong emotions or thoughts?",
        ]
    }
    
    static func getRandomTip() -> String {
        let tips = getTips()
        let randomIndex = rjCommon.getRandomInt(from: 0, to: tips.count-1)
        return tips[randomIndex]
    }
}
