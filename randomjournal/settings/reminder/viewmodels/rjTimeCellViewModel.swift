//
//  rjTimeCellViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-11-22.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import Bond

class rjTimeCellViewModel: rjCellViewModel, rjCellViewModelPressable {
    let title: String
    let timeOffset: Observable<Int>
    let timeOffsetReadable: Observable<String>
    let isExpanded = Observable(false)
    let timeSelectCellViewModel: rjTimeSelectCellViewModel
    
    let cellIdentifier = "time"
    var cellPressed: (() -> Void)?
    let identifiableComponent = rjIdentifiableComponent()

    init(title:String, time:Int) {
        self.title = title
        self.timeOffset = Observable(time)
        self.timeOffsetReadable = Observable(rjCommon.getReadableTimeOffset(time))
        
        let date = rjCommon.getDate(offset: self.timeOffset.value)
        timeSelectCellViewModel = rjTimeSelectCellViewModel(selectedTime: date)
        timeSelectCellViewModel.timeCell = self
        
        _ = timeSelectCellViewModel.selectedTime.observeNext() { [weak self] date in
            self?.timeOffset.value = rjCommon.getOffset(date: date)
        }
        
        _ = timeOffset.observeNext() { [weak self] offset in
            self?.timeOffsetReadable.value = rjCommon.getReadableTimeOffset(offset)
        }
    }
    
    func toggleState() {
        isExpanded.value = !isExpanded.value
    }
}
