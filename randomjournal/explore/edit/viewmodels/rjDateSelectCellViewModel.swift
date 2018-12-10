//
//  DateCellViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import Bond

class rjDateSelectCellViewModel: rjCellViewModel, rjCellViewModelPressable {
    let title: String
    let dateReadable: Observable<String>
    let selectedDate: Observable<Date>
    let isExpanded = Observable<Bool>(false)
    let cellIdentifier = "dateselect"
    let identifiableComponent = rjIdentifiableComponent()
    var cellPressed: (()->Void)?
    
    init(title: String, date: Date) {
        self.title = title
        self.dateReadable = Observable(rjCommon.getReadableDateLong(date))
        selectedDate = Observable(date)
        
        setupBind()
    }
    
    func setupBind() {
        selectedDate.map { "\(rjCommon.getReadableDateLong($0))" }.bind(to: dateReadable)
    }
    
    func toggleState() {
        isExpanded.value = !isExpanded.value
    }
}
