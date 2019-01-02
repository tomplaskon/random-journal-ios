//
//  rjSettingsCellViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-03.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

class rjCommonButtonCellViewModel {
    let buttonText: String
    let buttonAction: (() -> ())?
    
    init(buttonText: String, buttonAction: (() -> ())? = nil) {
        self.buttonText = buttonText
        self.buttonAction = buttonAction
    }    
}
