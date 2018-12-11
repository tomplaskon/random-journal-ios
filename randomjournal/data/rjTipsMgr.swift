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
            "What emotions are you experiencing?",
            "What were you thinking about?",
            "Are you with anyone else?",
        ]
    }
    
    static func getAnotherTip(_ currentTip : String?) -> String {
        var tips = getTips()
        
        if let curTip = currentTip {
            // remove the current tip from the array so we don't show it twice in a row
            tips = tips.filter { a in
                return a != curTip
            }
        }
        
        let randomIndex = rjCommon.getRandomInt(from: 0, to: tips.count-1)
        return tips[randomIndex]
    }
}
