//
//  rjReminderMgr.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-15.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit
import RealmSwift

class rjReminderMgr {
    @discardableResult
    func addReminder(_ reminder: rjReminder) -> String {
        let realm = try! Realm()
        try! realm.write {
            realm.add(reminder);
        }
        
        return reminder.reminderId
    }
    
    func getReminderById(_ reminderId : String) -> rjReminder {
        let realm = try! Realm()
        return realm.object(ofType: rjReminder.self, forPrimaryKey: reminderId)!
    }
    
    // returns a dictionary that maps reminderId => rjReminder
    func allRemindersMap() -> [String: rjReminder] {
        let realm = try! Realm()
        let reminders = realm.objects(rjReminder.self)
        return Dictionary(uniqueKeysWithValues: reminders.map{ ($0.reminderId, $0) })
    }
    
    func deleteReminder(_ reminder: rjReminder) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(reminder)
        }
    }
    
    func deleteAllReminders() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(rjReminder.self))
        }
    }
}
