//
//  rjMomentsViewModelProtocol.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-19.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import Bond

protocol rjMomentsViewModelProtocol {
    var momentCellViewModels: MutableObservableArray<rjMomentsViewModel.rjCellViewModel> { get }
    var momentToViewDetails: Observable<rjMomentViewModel?> { get }
    
    func start()
    func update()
    func tappedCell(index: Int)
}
