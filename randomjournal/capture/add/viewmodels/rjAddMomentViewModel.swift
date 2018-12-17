//
//  rjAddMomentViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-14.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import Bond

class rjAddMomentViewModel {
    
    let momentDetails = Observable("")
    
    private var currentTip: String?
    private var tutorialTips = [String]()
    
    init() {
        // if we have no moments, get the tutorial tips for our first experience
        if rjMomentViewModelRepository.shared.isEmpty {
            tutorialTips = rjTipsMgr.getTutorialTips().reversed()
            momentDetails.value = "Making my first entry in Presently!"
        }
    }
    
    func getAnotherTip() -> String {
        let tip = getAnotherTip(excluding: currentTip)
        currentTip = tip
        
        return tip
    }
    
    private func getAnotherTip(excluding tip: String?) -> String {
        if let tutorialTip = tutorialTips.popLast() {
            return tutorialTip
        }
        
        return rjTipsMgr.getAnotherTip(tip)
    }
}
