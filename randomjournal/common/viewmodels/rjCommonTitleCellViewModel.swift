//
//  rjCommonTitleCellViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-03.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

struct rjCommonTitleCellViewModel: rjCellViewModel {
    let title: String
    
    let identifiableComponent = rjIdentifiableComponent()
    let cellIdentifier = rjCommon.commonTitleReuseId
}
