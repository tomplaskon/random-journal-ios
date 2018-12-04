//
//  rjSettingsViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-03.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import Bond

class rjSettingsViewModel {
    let cellViewModels = MutableObservableArray<rjCellViewModel>()
    let destination = Observable<String?>(nil)
    let selector = Observable<String?>(nil)
    let reminderSchedule = Observable<String?>(nil)
    let showTutorial = Observable<Bool>(false)
    let CSVExportViewModel = Observable<rjCSVExportViewModel?>(nil)
    
    func start() {
        buildViewModels()
    }
    
    func buildViewModels() {
        cellViewModels.append(rjCommonTitleCellViewModel(title: "Settings"))
        cellViewModels.append(rjCommonButtonCellViewModel(buttonText: "Reminders") { [weak self] in
            self?.destination.value = "reminders"
        })
        cellViewModels.append(rjCommonButtonCellViewModel(buttonText: "Tutorial") { [weak self] in
            self?.showTutorial.value = true
        })
        cellViewModels.append(rjCommonButtonCellViewModel(buttonText: "Export CSV") { [weak self] in
            self?.exportCSV()
        })
        cellViewModels.append(rjCommonButtonCellViewModel(buttonText: "Import CSV") { [weak self] in
            self?.destination.value = "import"
        })
        cellViewModels.append(rjCommonButtonCellViewModel(buttonText: "Show Reminder Schedule") { [weak self] in
            rjReminderScheduler.shared.getCurrentScheduleReadable() { schedule in
            self?.reminderSchedule.value = schedule
            }
        })
    }
    
    func exportCSV() {
        if let fileURL = rjMomentExporter().exportMomentsToFile(), let fileData = try? Data(contentsOf: fileURL) {
            let fileName = fileURL.lastPathComponent
            CSVExportViewModel.value = rjCSVExportViewModel(fileURL: fileURL, fileName: fileName, fileData: fileData)
        }
    }
}
