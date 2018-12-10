//
//  rjEditDetailsViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import Bond

class rjEditDetailsViewModel: rjCellViewModel {
    let details: Observable<String?>
    let cellIdentifier = "details"
    let identifiableComponent = rjIdentifiableComponent()
    
    init(details: String) {
        self.details = Observable(details)
    }
}
