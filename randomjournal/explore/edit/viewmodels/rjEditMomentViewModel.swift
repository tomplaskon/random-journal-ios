//
//  rjEditMomentViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import Bond

class rjEditMomentViewModel {
    let cellViewModels = MutableObservableArray<rjCellViewModel>()
    var returnToRoot = Observable<Bool>(false)
    
    private var moment: rjMoment?
    private var momentDetails = Observable<String?>(nil)
    private var momentWhen = Observable<Int?>(nil)

    init() {
        
    }
    
    func start(moment: rjMoment) {
        self.moment = moment
        buildCellViewModels(moment: moment)
    }
    
    private func buildCellViewModels(moment: rjMoment) {
        let title = rjCommonTitleCellViewModel(title: "Edit Moment")
        cellViewModels.append(title)
        
        let dateSelect = makeDateSelectCellViewModel(date: moment.whenDate)
        cellViewModels.append(dateSelect)
        
        let details = makeDetailsCellViewModel(details: moment.details)
        cellViewModels.append(details)

        let spacer = rjCommonSpacerCellViewModel()
        cellViewModels.append(spacer)
 
        let save = rjCommonButtonCellViewModel(buttonText: "Save") { [weak self] in
            self?.saveMoment()
        }
        cellViewModels.append(save)
    }
    
    private func makeDateSelectCellViewModel(date: Date) -> rjDateSelectCellViewModel {
        let viewModel = rjDateSelectCellViewModel(title: "When", date: date)
        _ = viewModel.cellPressed = { [weak viewModel] in
            viewModel?.toggleState()
        }
        viewModel.selectedDate.map{ Int($0.timeIntervalSince1970) }.bind(to: momentWhen)
        
        return viewModel
    }
    
    private func makeDetailsCellViewModel(details: String) -> rjEditDetailsViewModel {
        let viewModel = rjEditDetailsViewModel(details: details)
        viewModel.details.bind(to: momentDetails)
        
        return viewModel
    }
    
    func saveMoment() {
        if let moment = moment, let details = momentDetails.value, let when = momentWhen.value {

            rjMomentMgr().updateMoment(moment.momentId, when: when, details: details)
            
            let del = UIApplication.shared.delegate as! rjAppDelegate
            del.momentsUpdated = true
            
            returnToRoot.value = true
        }
    }
}
