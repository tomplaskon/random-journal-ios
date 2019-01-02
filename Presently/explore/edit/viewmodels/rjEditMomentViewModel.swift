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
    enum rjCellViewModel {
        case title(rjCommonTitleCellViewModel)
        case dateSelect(rjDateSelectCellViewModel)
        case details(rjEditDetailsCellViewModel)
        case spacer(rjCommonSpacerCellViewModel)
        case save(rjCommonButtonCellViewModel)
        
        var viewModel: Any {
            switch self {
            case .title(let viewModel):
                return viewModel
            case .dateSelect(let viewModel):
                return viewModel
            case .details(let viewModel):
                return viewModel
            case .spacer(let viewModel):
                return viewModel
            case .save(let viewModel):
                return viewModel
            }
        }
    }
    
    let cellViewModels = MutableObservableArray<rjCellViewModel>()
    var returnToRoot = Observable<Bool>(false)
    
    private var moment: rjMomentViewModel?
    private var momentDetails = Observable<String?>(nil)
    private var momentWhen = Observable<Date?>(nil)

    func start(moment: rjMomentViewModel) {
        self.moment = moment
        buildCellViewModels(moment: moment)
    }
    
    private func buildCellViewModels(moment: rjMomentViewModel) {
        let title = rjCommonTitleCellViewModel(title: "Edit Moment")
        cellViewModels.append(.title(title))
        
        let dateSelect = makeDateSelectCellViewModel(date: moment.when.date)
        cellViewModels.append(.dateSelect(dateSelect))
        
        let details = makeDetailsCellViewModel(details: moment.details)
        cellViewModels.append(.details(details))

        let spacer = rjCommonSpacerCellViewModel()
        cellViewModels.append(.spacer(spacer))
 
        let save = rjCommonButtonCellViewModel(buttonText: "Save") { [weak self] in
            self?.saveMoment()
        }
        cellViewModels.append(.save(save))
    }
    
    private func makeDateSelectCellViewModel(date: Date) -> rjDateSelectCellViewModel {
        let viewModel = rjDateSelectCellViewModel(title: "When", date: date)
        _ = viewModel.cellPressed = { [weak viewModel] in
            viewModel?.toggleState()
        }
        viewModel.selectedDate.bind(to: momentWhen)
        
        return viewModel
    }
    
    private func makeDetailsCellViewModel(details: String) -> rjEditDetailsCellViewModel {
        let viewModel = rjEditDetailsCellViewModel(details: details)
        viewModel.details.bind(to: momentDetails)
        
        return viewModel
    }
    
    func saveMoment() {
        if let moment = moment, let details = momentDetails.value, let when = momentWhen.value {
            
            let momentMgr = rjMomentViewModelRepository.shared
            let momentModel = rjMomentViewModel(
                id: moment.id,
                when: when,
                details: details
            )
            momentMgr.update(momentModel)
            momentMgr.notifyMomentsUpdated()
            
            returnToRoot.value = true
        }
    }
    
    func tappedCell(index: Int) {
        let cellViewModel = cellViewModels[index].viewModel
        if let cellViewModel = cellViewModel as? rjCellViewModelPressable {
            cellViewModel.cellPressed?()
        }
    }
}
