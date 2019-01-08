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
    enum rjCellViewModel {
        case timeSelect(rjTimeSelectCellViewModel)
        case reminderStatus(rjReminderStatusCellViewModel)
        
        var viewModel: Any {
            switch self {
            case .timeSelect(let viewModel):
                return viewModel
            case .reminderStatus(let viewModel):
                return viewModel
            }
        }
    }
    
    let cellViewModels = MutableObservableArray<rjCellViewModel>()
    var nextReminderAt = Observable("")
    
    private var reminderStatusCellViewModel: rjReminderStatusCellViewModel?
    
    func start() {
        buildViewModels()
        updateNextReminderAt()
        reminderStatusCellViewModel?.start()
    }
    
    func buildViewModels() {
        let reminderStatus = makeReminderStatusCellViewModel()
        cellViewModels.append(.reminderStatus(reminderStatus))
        reminderStatusCellViewModel = reminderStatus
        
        let startTime = makeStartTimeCellViewModel()
        cellViewModels.append(.timeSelect(startTime))
        
        let endTime = makeEndTimeCellViewModel()
        cellViewModels.append(.timeSelect(endTime))
        
        // update the Next Reminder text if the reminder settings are changed
        _ = reminderStatus.remindersEnabled.observeNext { [weak self] enabled in
            self?.updateNextReminderAt()
        }
        _ = startTime.selectedTime.observeNext { [weak self] time in
            self?.updateNextReminderAt()
        }
        _ = endTime.selectedTime.observeNext { [weak self] time in
            self?.updateNextReminderAt()
        }
    }
    
    func updateNextReminderAt() {
        rjReminderScheduler.shared.areNotificationsEnabled { [weak self] enabled in
            if enabled {
                if let reminder = rjReminderMgr().getNextReminder() {
                    let format = "MMM d @ h:mm a" // Jan 8 @ 4:05 PM
                    self?.nextReminderAt.value = "Next reminder at " + reminder.getTriggerDate().with(format: format)
                } else {
                    self?.nextReminderAt.value = "No reminders scheduled"
                }
            } else {
                self?.nextReminderAt.value = "No reminders scheduled"
            }
        }
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
            let currentOffset = rjAppSettings.shared.getReminderStartTimeOffset()
            let newOffset = rjCommon.getOffset(date: date)
            
            if newOffset != currentOffset {
                rjAppSettings.shared.setReminderStartTimeOffset(newOffset)
                let scheduler = rjReminderScheduler.shared
                scheduler.clearReminders()
                scheduler.updateReminders()
            }
        }
        
        return startTime
    }
    
    func makeEndTimeCellViewModel() -> rjTimeSelectCellViewModel {
        let endTime = rjTimeSelectCellViewModel(title: "End time", time: rjAppSettings.shared.getReminderEndTimeOffset())
        endTime.cellPressed = { [weak endTime] in
            endTime?.toggleState()
        }
        _ = endTime.selectedTime.observeNext() { date in
            let currentOffset = rjAppSettings.shared.getReminderEndTimeOffset()
            let newOffset = rjCommon.getOffset(date: date)
            
            if newOffset != currentOffset {
                rjAppSettings.shared.setReminderEndTimeOffset(newOffset)
                let scheduler = rjReminderScheduler.shared
                scheduler.clearReminders()
                scheduler.updateReminders()
            }
        }
        
        return endTime
    }
    
    func tappedCell(index: Int) {
        let cellViewModel = cellViewModels[index].viewModel
        if let cellViewModel = cellViewModel as? rjCellViewModelPressable {
            cellViewModel.cellPressed?()
        }
    }
}
