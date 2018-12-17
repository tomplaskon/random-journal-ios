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
    func addMoment(when: Date, details: String) -> String {
        let moment = rjMoment()
        
        let momentModel = rjMomentViewModel(id: NSUUID().uuidString, when: when, details: details)
        moment.populate(momentModel)
        
        return addMoment(moment)
    }
    
    @discardableResult
    private func addMoment(_ moment: rjMoment) -> String {
        let realm = rjRealmMgr.shared.defaultRealm
        
        try! realm.write {
            realm.add(moment);
        }
        
        return moment.momentId
    }
    
    func importMoment(_ momentModel: rjMomentViewModel) -> Bool {
        if let _ = self.getMomentById(momentModel.id) {
            return false
        }
        
        let moment = rjMoment()
        moment.populate(momentModel)
        
        addMoment(moment)
        
        return true
    }
    
    func getMomentById(_ momentId: String) -> rjMomentViewModel? {
        if let moment = getMomentDataModelById(momentId) {
            return rjMomentViewModel(moment)
        }
        return nil
    }
    
    private func getMomentDataModelById(_ momentId: String) -> rjMoment? {
        let realm = rjRealmMgr.shared.defaultRealm
        if let moment = realm.object(ofType: rjMoment.self, forPrimaryKey: momentId) {
            return moment
        }
        return nil
    }
    
    func getPreviousMoment(_ momentModel: rjMomentViewModel) -> rjMomentViewModel? {
        let moments = allMoments()
        if let momentIndex = moments.firstIndex(of: momentModel) {
            let previousMomentIndex = momentIndex + 1
            if (previousMomentIndex < moments.count) {
                return moments[previousMomentIndex]
            }
        }
        
        return nil
    }

    func getNextMoment(_ momentModel: rjMomentViewModel) -> rjMomentViewModel? {
        let moments = allMoments()
        if let momentIndex = moments.firstIndex(of: momentModel) {
            let nextMomentIndex = momentIndex - 1
            if (nextMomentIndex >= 0) {
                return moments[nextMomentIndex]
            }
        }
        
        return nil
    }
    
    func getRandomMoment() -> rjMomentViewModel? {
        let moments = allMoments()
        
        if moments.isEmpty {
            return nil
        }
        
        let randomIndex = rjCommon.getRandomInt(from: 0, to: moments.count-1)
        return moments[randomIndex]
    }
    
    func getMomentsBetween(from startDate: Date, to endDate: Date) -> [rjMomentViewModel] {
        let realm = rjRealmMgr.shared.defaultRealm
        
        let predicate = NSPredicate(format: "when >= %d and when <= %d", Int(startDate.timeIntervalSince1970), Int(endDate.timeIntervalSince1970))
        
        return realm.objects(rjMoment.self).filter(predicate).map { rjMomentViewModel($0) }
    }
    
    func allMoments() -> Array<rjMomentViewModel> {
        let realm = rjRealmMgr.shared.defaultRealm
        let sort = [SortDescriptor(keyPath: "when", ascending: false), SortDescriptor(keyPath: "momentId", ascending: true)]

        return Array(realm.objects(rjMoment.self).sorted(by:sort).map { rjMomentViewModel($0) })
    }
    
    @discardableResult
    func deleteMoment(_ momentId: String) -> Bool {
        let realm = rjRealmMgr.shared.defaultRealm
        
        guard let moment = getMomentDataModelById(momentId) else {
            return false
        }
        
        try! realm.write {
            realm.delete(moment)
        }
        
        return true
    }
    
    @discardableResult
    func updateMoment(_ momentModel: rjMomentViewModel) -> Bool {
        guard let moment = self.getMomentDataModelById(momentModel.id) else {
            return false
        }
        
        let realm = rjRealmMgr.shared.defaultRealm
        try! realm.write {
            moment.populate(momentModel, updateId: false)
        }
        return true
    }
    
    func notifyMomentsUpdated() {
        NotificationCenter.default.post(name: .momentsUpdated, object: nil)
    }
    
    var isEmpty: Bool {
        let realm = rjRealmMgr.shared.defaultRealm
        return realm.objects(rjMoment.self).isEmpty
    }
}
