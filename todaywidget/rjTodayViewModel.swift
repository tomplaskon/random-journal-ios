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
    let moment = Observable<rjMomentViewModel?>(nil)
    
    func start() {
        update()
    }
    
    func update() {
        let momentMgr = rjMomentMgr()
        if let momentModel = momentMgr.getRandomMoment() {
            moment.value = momentModel
        } else {
            moment.value = nil
        }
    }
}
