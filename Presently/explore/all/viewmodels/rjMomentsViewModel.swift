//
//  rjMomentsViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-10.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import Bond

class rjMomentsViewModel: rjMomentsViewModelProtocol {
    enum rjCellViewModel: Equatable {
        case empty()
        case summaryGraph(rjMomentSummaryGraphCellViewModel)
        case moment(rjMomentViewModel)
    }

    let momentCellViewModels = MutableObservableArray<rjCellViewModel>()
    let momentToViewDetails = Observable<rjMomentViewModel?>(nil)
    fileprivate let momentRepository: rjMomentEntityModelRepositoryProtocol

    init(momentRepository: rjMomentEntityModelRepositoryProtocol = rjMomentEntityModelRepository.shared) {
        self.momentRepository = momentRepository
    }
    
    func start() {
        reloadMoments()
    }
    
    func update() {
        reloadMoments()
    }
    
    fileprivate func reloadMoments() {
        let moments = momentRepository.all().map{ rjCellViewModel.moment(rjMomentViewModel($0)) }
        
        if !moments.isEmpty {
            var viewModels = [rjCellViewModel]()
            
            let summaryCellViewModel = makeGraphSummaryCellViewModel()
            viewModels.append(.summaryGraph(summaryCellViewModel))
            
            viewModels.append(contentsOf: moments)
            
            momentCellViewModels.replace(with: viewModels)
        } else {
            momentCellViewModels.replace(with: [.empty()])
        }
    }
    
    fileprivate func makeGraphSummaryCellViewModel() -> rjMomentSummaryGraphCellViewModel {
        
        let today = rjCommon.getDateAtEndOfDay(Date())
        let sevenDaysAgo = rjCommon.getDateAtBeginningOfDay(rjCommon.subtract(days: 6, from: today))
        
        var summaryGraphViewModel = rjMomentSummaryGraphViewModel(startDate: sevenDaysAgo, endDate: today)
        let graphMoments = rjMomentEntityModelRepository.shared.getBetween(from: sevenDaysAgo, to: today)
        summaryGraphViewModel.add(moments: graphMoments)
        
        return rjMomentSummaryGraphCellViewModel(
            summaryViewModel: summaryGraphViewModel
        )
    }
    
    func tappedCell(index: Int) {
        switch momentCellViewModels[index] {
        case .moment(let moment):
            momentToViewDetails.value = moment
        default:
            break
        }
    }
}
