//
//  rjTimeCellViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-11-22.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import Bond

class rjTimeSelectCellViewModel: rjCellViewModel, rjCellViewModelPressable {
    let title: String
    let selectedTime: Observable<Date>
    let timeOffsetReadable: Observable<String>
    let isExpanded = Observable(false)
    let cellIdentifier = "timeselect"
    var cellPressed: (() -> Void)?

    init(title:String, time:Int) {
        self.title = title
        selectedTime = Observable(rjCommon.getDate(offset: time))
        self.timeOffsetReadable = Observable(rjCommon.getReadableTimeOffset(time))
        
        setupBind()
    }
    
    func setupBind() {
        selectedTime.map { "\(rjCommon.getReadableTimeOffset(rjCommon.getOffset(date: $0)))" }.bind(to: timeOffsetReadable)
    }
    
    func toggleState() {
        isExpanded.value = !isExpanded.value
    }
}
