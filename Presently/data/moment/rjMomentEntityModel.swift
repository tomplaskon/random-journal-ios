//
//  rjMomentEntityModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-17.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

struct rjMomentEntityModel: Equatable {
    var id: String
    var when: Date
    var details: String
    
    init(_ persistenceModel: rjMomentPersistenceModel) {
        id = persistenceModel.momentId
        when = Date(timeIntervalSince1970: TimeInterval(persistenceModel.when))
        details = persistenceModel.details
    }
    
    init(id: String, when: Date, details: String) {
        self.id = id
        self.when = when
        self.details = details
    }
}
