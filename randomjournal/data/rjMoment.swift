//
//  rjMoment.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit
import RealmSwift

class rjMoment: Object {
    @objc dynamic var momentId = "" // the moment's id
    @objc dynamic var when = 0 // when did the moment take place (unix timestamp)
    @objc dynamic var details = "" // the text details describing the moment
    
    // make momentId the primary key
    override static func primaryKey() -> String? {
        return "momentId"
    }

    func populate(_ momentModel: rjMomentModel, updateId: Bool = true) {
        if updateId {
            self.momentId = momentModel.id
        }
        self.when = momentModel.whenInt
        self.details = momentModel.details
    }
    
    func whenReadableLong() -> String {
        return rjCommon.getReadableDateLong(whenDate)
    }
    
    var whenDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(when))
    }
}
