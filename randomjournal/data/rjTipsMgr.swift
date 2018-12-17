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
            "What's around you?",
            "What emotions are you experiencing?",
            "What were you thinking about?",
            "Are you with anyone else?",
            "Where are you?",
        ]
    }
    
    static func getAnotherTip(_ currentTip : String?) -> String {
        var tips = getTips()
        
        if let currentTip = currentTip {
            // remove the current tip from the array so we don't show it twice in a row
            tips = tips.filter { $0 != currentTip }
        }
        
        let randomIndex = rjCommon.getRandomInt(from: 0, to: tips.count-1)
        return tips[randomIndex]
    }
    
    // curated tips for your first writing experience
    static func getTutorialTips() -> [String] {
        return [
            "Where are you?",
            "What's around you?",
            "Are there any prominent colors?",
            "Are you touching anything? What is its texture like?",
        ]
    }
}
