//
//  rjIdentifiableComponent.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-11-28.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

struct rjIdentifiableComponent: Equatable {
    var id = UUID().uuidString
    
    static func == (lhs: rjIdentifiableComponent, rhs: rjIdentifiableComponent) -> Bool {
        return lhs.id == rhs.id
    }
}
