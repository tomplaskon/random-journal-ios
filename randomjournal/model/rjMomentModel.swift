//
//  rjMomentModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-10.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

struct rjMomentModel: Equatable {
    var id: String
    var when: Date
    var details: String
    
    init(_ moment: rjMoment) {
        self.id = moment.momentId
        self.when = Date(timeIntervalSince1970: TimeInterval(moment.when))
        self.details = moment.details
    }
    
    init(id: String, when: Date, details: String) {
        self.id = id
        self.when = when
        self.details = details
    }
    
    func whenReadableLong() -> String {
        return rjCommon.getReadableDateLong(when)
    }
    
    var whenInt: Int {
        return Int(when.timeIntervalSince1970)
    }
}
