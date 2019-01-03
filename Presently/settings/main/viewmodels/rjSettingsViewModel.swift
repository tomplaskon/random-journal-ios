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
    enum rjCellViewModel {
        case title(rjCommonTitleCellViewModel)
        case button(rjCommonButtonCellViewModel)
    }
    
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
        cellViewModels.append(.title(
            rjCommonTitleCellViewModel(title: "Settings")
        ))
        cellViewModels.append(.button(
            rjCommonButtonCellViewModel(buttonText: "Reminders") { [weak self] in
                self?.destination.value = "reminders"
            }
        ))
        cellViewModels.append(.button(
            rjCommonButtonCellViewModel(buttonText: "Export Moments") { [weak self] in
                self?.exportCSV()
            }
        ))
        cellViewModels.append(.button(
            rjCommonButtonCellViewModel(buttonText: "Import Moments") { [weak self] in
                self?.destination.value = "import"
            }
        ))
        
        if rjEnvironment.isTestBuild {
            cellViewModels.append(.button(
                rjCommonButtonCellViewModel(buttonText: "Tutorial") { [weak self] in
                    self?.showTutorial.value = true
                }
                ))
            cellViewModels.append(.button(
                rjCommonButtonCellViewModel(buttonText: "Show Reminder Schedule") { [weak self] in
                    rjReminderScheduler.shared.getCurrentScheduleReadable() { schedule in
                        self?.reminderSchedule.value = schedule
                    }
                }
            ))
        }
    }
    
    func exportCSV() {
        if let fileURL = rjMomentExporter().exportMomentsToFile(), let fileData = try? Data(contentsOf: fileURL) {
            let fileName = fileURL.lastPathComponent
            CSVExportViewModel.value = rjCSVExportViewModel(fileURL: fileURL, fileName: fileName, fileData: fileData)
        }
    }
}
