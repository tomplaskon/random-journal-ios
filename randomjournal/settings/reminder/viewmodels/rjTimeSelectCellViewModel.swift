//
//  rjTimeSelectCellViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-11-22.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import Bond

class rjTimeSelectCellViewModel: rjCellViewModel {
    weak var timeCell: rjTimeCellViewModel?
    
    let cellIdentifier = "timeselect"
    let identifiableComponent = rjIdentifiableComponent()
    let selectedTime: Observable<Date>
    
    init(selectedTime: Date) {
        self.selectedTime = Observable<Date>(selectedTime)
    }
}
