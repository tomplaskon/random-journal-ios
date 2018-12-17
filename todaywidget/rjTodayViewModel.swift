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
        let momentMgr = rjMomentViewModelRepository.shared
        if let momentModel = momentMgr.getRandom() {
            moment.value = momentModel
        } else {
            moment.value = nil
        }
    }
}
