//
//  rjMomentMgr.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit
import RealmSwift

class rjMomentMgr {
    @discardableResult
    func addMoment(_ moment: rjMoment) -> String {
        let realm = try! Realm()
        
        moment.momentId = NSUUID().uuidString;
        
        try! realm.write {
            realm.add(moment);
        }
        
        return moment.momentId
    }
    
    func importMoment(_ moment: rjMoment) -> Bool {
        if let _ = self.getMomentById(moment.momentId) {
            return false
        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(moment);
        }
        
        return true
    }
    
    func getMomentById(_ momentId : String) -> rjMoment? {
        let realm = try! Realm()
        return realm.object(ofType: rjMoment.self, forPrimaryKey: momentId)
    }
    
    func getPreviousMoment(_ moment : rjMoment) -> rjMoment? {
        let moments = allMoments()
        if let momentIndex = moments.index(of: moment) {
            let previousMomentIndex = momentIndex + 1
            if (previousMomentIndex < moments.count) {
                return moments[previousMomentIndex]
            }
        }
        
        return nil
    }

    func getNextMoment(_ moment : rjMoment) -> rjMoment? {
        let moments = allMoments()
        if let momentIndex = moments.index(of: moment) {
            let nextMomentIndex = momentIndex - 1
            if (nextMomentIndex >= 0) {
                return moments[nextMomentIndex]
            }
        }
        
        return nil
    }
    
    func getRandomMoment() -> rjMoment {
        let moments = allMoments()
        let randomIndex = rjCommon.getRandomInt(from: 0, to: moments.count-1)
        return moments[randomIndex]
    }
    
    func allMoments() -> Array<rjMoment> {
        let realm = try! Realm()
        let sort = [SortDescriptor(keyPath: "when", ascending: false), SortDescriptor(keyPath: "momentId", ascending: true)]

        return Array(realm.objects(rjMoment.self).sorted(by:sort))
    }
    
    func deleteMoment(_ moment: rjMoment) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(moment)
        }
    }
}
