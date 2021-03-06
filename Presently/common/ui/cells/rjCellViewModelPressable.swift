//
//  rjRowViewModelPressable.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-11-22.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

protocol rjCellViewModelPressable {
    var cellPressed: (()->Void)? { get set }
}
