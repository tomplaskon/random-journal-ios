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
    var realm = try! Realm()
    
    @discardableResult
    func addMoment(_ moment: rjMoment) -> String {
        moment.momentId = NSUUID().uuidString;
        
        try! realm.write {
            realm.add(moment);
        }
        
        return moment.momentId
    }
    
    func getMomentById(_ momentId : String) -> rjMoment {
        return realm.object(ofType: rjMoment.self, forPrimaryKey: momentId)!
    }
    
    func allMoments() -> Array<rjMoment> {
        let sortFields = [SortDescriptor(keyPath: "when", ascending: false), SortDescriptor(keyPath: "momentId")]
        return Array(realm.objects(rjMoment.self).sorted(by:sortFields))
    }
    
    func deleteMoment(_ moment: rjMoment) {
        try! realm.write {
            realm.delete(moment)
        }
    }
}
