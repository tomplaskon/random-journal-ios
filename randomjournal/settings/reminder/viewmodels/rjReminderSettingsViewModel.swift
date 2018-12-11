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
    
    private var reminderStatusCellViewModel: rjReminderStatusCellViewModel?
    
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
        
        let endTime = makeEndTimeCellViewModel()
        cellViewModels.append(endTime)
    }
    
    func makeReminderStatusCellViewModel() -> rjReminderStatusCellViewModel {
        let reminderStatus = rjReminderStatusCellViewModel(title: "Reminders enabled", remindersEnabled: false)
        
        return reminderStatus
    }
    
    func makeStartTimeCellViewModel() -> rjTimeSelectCellViewModel {
        let startTime = rjTimeSelectCellViewModel(title: "Start time", time: rjAppSettings.shared.getReminderStartTimeOffset())
        startTime.cellPressed = { [weak startTime] in
            startTime?.toggleState()
        }
        _ = startTime.selectedTime.observeNext() { date in
            rjAppSettings.shared.setReminderStartTimeOffset(rjCommon.getOffset(date: date))
            let scheduler = rjReminderScheduler.shared
            scheduler.clearReminders()
            scheduler.updateReminders()
        }
        
        return startTime
    }
    
    func makeEndTimeCellViewModel() -> rjTimeSelectCellViewModel {
        let endTime = rjTimeSelectCellViewModel(title: "End time", time: rjAppSettings.shared.getReminderEndTimeOffset())
        endTime.cellPressed = { [weak endTime] in
            endTime?.toggleState()
        }
        _ = endTime.selectedTime.observeNext() { date in
            rjAppSettings.shared.setReminderEndTimeOffset(rjCommon.getOffset(date: date))
            let scheduler = rjReminderScheduler.shared
            scheduler.clearReminders()
            scheduler.updateReminders()
        }
        
        return endTime
    }
}
