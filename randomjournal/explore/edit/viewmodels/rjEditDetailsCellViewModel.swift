//
//  rjEditDetailsViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import Bond

class rjEditDetailsCellViewModel {
    let details: Observable<String?>
    
    init(details: String) {
        self.details = Observable(details)
    }
}
