//
//  rjTodayViewModel.swift
//  todaywidget
//
//  Created by Tom Plaskon on 2018-12-05.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import Bond

class rjTodayViewModel {
    struct rjMomentViewModel {
        let date: String
        let details: String
    }
    
    let moment = Observable<rjMomentViewModel?>(nil)
    
    func start() {
        update()
    }
    
    func update() {
        let momentMgr = rjMomentMgr()
        let momentData = momentMgr.getRandomMoment()
        
        if let momentData = momentData {
            moment.value = rjMomentViewModel(date: momentData.whenReadableLong(), details: momentData.details)
        } else {
            moment.value = rjMomentViewModel(date: "", details: "No moments to display")
        }
    }
}
