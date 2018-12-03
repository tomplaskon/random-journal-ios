//
//  rjIdentifiable.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-11-28.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

protocol rjIdentifiable {
    var identifiableComponent: rjIdentifiableComponent { get }
}
