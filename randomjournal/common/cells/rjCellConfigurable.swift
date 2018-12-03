//
//  rjCellConfigurable.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-11-22.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

protocol rjCellConfigurable {
    func setup(viewModel: rjCellViewModel) // configure the cell's UI using the View Model
}
