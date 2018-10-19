//
//  rjReminder.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-08.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit
import RealmSwift

class rjReminder: Object {
    @objc dynamic var triggerTime = 0
    @objc dynamic var reminderId = NSUUID().uuidString
    
    // make momentId the primary key
    override static func primaryKey() -> String? {
        return "reminderId"
    }
    
    func update() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    func getTimeIntervalFromNow() -> Int {
        return self.triggerTime - rjCommon.unixTimestamp()
    }
    
    func getTriggerDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self.triggerTime))
    }
}
