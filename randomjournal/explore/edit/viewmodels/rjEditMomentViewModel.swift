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
    
    private var moment: rjMomentModel?
    private var momentDetails = Observable<String?>(nil)
    private var momentWhen = Observable<Date?>(nil)

    init() {
        
    }
    
    func start(moment: rjMomentModel) {
        self.moment = moment
        buildCellViewModels(moment: moment)
    }
    
    private func buildCellViewModels(moment: rjMomentModel) {
        let title = rjCommonTitleCellViewModel(title: "Edit Moment")
        cellViewModels.append(title)
        
        let dateSelect = makeDateSelectCellViewModel(date: moment.when)
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
        viewModel.selectedDate.bind(to: momentWhen)
        
        return viewModel
    }
    
    private func makeDetailsCellViewModel(details: String) -> rjEditDetailsViewModel {
        let viewModel = rjEditDetailsViewModel(details: details)
        viewModel.details.bind(to: momentDetails)
        
        return viewModel
    }
    
    func saveMoment() {
        if var moment = moment, let details = momentDetails.value, let when = momentWhen.value {

            moment.when = when
            moment.details = details
            
            let momentMgr = rjMomentMgr()
            momentMgr.updateMoment(moment)
            momentMgr.notifyMomentsUpdated()
            
            returnToRoot.value = true
        }
    }
}
