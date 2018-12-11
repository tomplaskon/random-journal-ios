//
//  rjMomentsViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-10.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import Bond

class rjMomentsViewModel {
    enum rjCellViewModel: Equatable {
        case empty()
        case moment(rjMomentViewModel)
    }
    
    let momentCellViewModels = MutableObservableArray<rjCellViewModel>()
    let momentToViewDetails = Observable<rjMomentViewModel?>(nil)
    
    func start() {
        reloadMoments()
    }
    
    func update() {
        reloadMoments()
    }
    
    func reloadMoments() {
        let moments = rjMomentMgr().allMoments().map{ rjCellViewModel.moment($0) }
        
        if !moments.isEmpty {
            momentCellViewModels.replace(with: moments)
        } else {
            momentCellViewModels.replace(with: [.empty()])
        }
    }
    
    func tappedMoment(index: Int) {
        switch momentCellViewModels[index] {
        case .moment(let moment):
            momentToViewDetails.value = moment
        default:
            break
        }
    }
}
