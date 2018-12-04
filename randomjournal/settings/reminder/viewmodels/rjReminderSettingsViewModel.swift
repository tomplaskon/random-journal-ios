//
//  rjReminderSettingsViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-11-27.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import Bond

class rjReminderSettingsViewModel {
    let cellViewModels = MutableObservableArray<rjCellViewModel>()
    
    var reminderStatusCellViewModel: rjReminderStatusCellViewModel?
    var startTimeCellViewModel: rjTimeCellViewModel?
    var endTimeCellViewModel: rjTimeCellViewModel?
    
    func start() {
        buildViewModels()
        reminderStatusCellViewModel?.start()
    }
    
    func buildViewModels() {
        let reminderStatus = makeReminderStatusCellViewModel()
        cellViewModels.append(reminderStatus)
        reminderStatusCellViewModel = reminderStatus
        
        let startTime = makeStartTimeCellViewModel()
        cellViewModels.append(startTime)
        startTimeCellViewModel = startTime
        
        let endTime = makeEndTimeCellViewModel()
        cellViewModels.append(endTime)
        endTimeCellViewModel = endTime
        
        updateCellViewModels()
    }
    
    func makeReminderStatusCellViewModel() -> rjReminderStatusCellViewModel {
        let reminderStatus = rjReminderStatusCellViewModel(title: "Reminders enabled", remindersEnabled: false)
        
        return reminderStatus
    }
    
    func makeStartTimeCellViewModel() -> rjTimeCellViewModel {
        let startTime = rjTimeCellViewModel(title: "Start time", time: rjAppSettings.shared.getReminderStartTimeOffset())
        _ = startTime.isExpanded.observeNext { [weak self] isExpanded in
            self?.updateCellViewModels()
        }
        startTime.cellPressed = { [weak startTime] in
            startTime?.toggleState()
        }
        _ = startTime.timeOffset.observeNext() { offset in
            rjAppSettings.shared.setReminderStartTimeOffset(offset)
        }
        
        return startTime
    }
    
    func makeEndTimeCellViewModel() -> rjTimeCellViewModel {
        let endTime = rjTimeCellViewModel(title: "End time", time: rjAppSettings.shared.getReminderEndTimeOffset())
        endTime.cellPressed = { [weak endTime] in
            endTime?.toggleState()
        }
        _ = endTime.isExpanded.observeNext { [weak self] isExpanded in
            self?.updateCellViewModels()
        }
        _ = endTime.timeOffset.observeNext() { offset in
            rjAppSettings.shared.setReminderEndTimeOffset(offset)
        }
        
        return endTime
    }
    
    func updateCellViewModels() {
        if let startTimeCellViewModel = startTimeCellViewModel {
            updateTimeCellViewModel(startTimeCellViewModel)
        }
        if let endTimeCellViewModel = endTimeCellViewModel {
            updateTimeCellViewModel(endTimeCellViewModel)
        }
    }
    
    func index(_ viewModel: rjCellViewModel) -> Int? {
        return cellViewModels.array.firstIndex() { arrViewModel in
            return arrViewModel.identifiableComponent == viewModel.identifiableComponent
        }
    }
    
    func updateTimeCellViewModel(_ timeCell: rjTimeCellViewModel) {
        if let timeCellIndex = index(timeCell) {
            if let timeSelectCellIndex = index(timeCell.timeSelectCellViewModel) {
                if !timeCell.isExpanded.value {
                    // timecell is not expanded but the timeselect cell is present, remove it
                    cellViewModels.remove(at: timeSelectCellIndex)
                }
            } else {
                if timeCell.isExpanded.value {
                    // timecell is expanded but the timeselect cell is not present, add it
                    cellViewModels.insert(timeCell.timeSelectCellViewModel, at: timeCellIndex+1)
                }
            }
        }
    }
}
