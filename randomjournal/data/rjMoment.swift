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
    
    func update() {
        let realm = rjRealmMgr.shared.defaultRealm
        
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    func whenReadableLong() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(when))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
}
