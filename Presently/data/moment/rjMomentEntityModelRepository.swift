//
//  rjMomentEntityModelRepository.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-17.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import RealmSwift

class rjMomentEntityModelRepository: rjMomentEntityModelRepositoryProtocol {
    static let shared = rjMomentEntityModelRepository()
    
    private init() {
        
    }
    
    @discardableResult
    func add(when: Date, details: String) -> String {
        let moment = rjMomentPersistenceModel()
        
        let momentModel = rjMomentEntityModel(id: NSUUID().uuidString, when: when, details: details)
        moment.populate(momentModel)
        
        return add(moment)
    }
    
    @discardableResult
    private func add(_ moment: rjMomentPersistenceModel) -> String {
        let realm = rjRealmMgr.shared.defaultRealm
        
        try! realm.write {
            realm.add(moment);
        }
        
        return moment.momentId
    }
    
    func importEntity(_ momentModel: rjMomentEntityModel) -> Bool {
        if let _ = self.getById(momentModel.id) {
            return false
        }
        
        let moment = rjMomentPersistenceModel()
        moment.populate(momentModel)
        
        add(moment)
        
        return true
    }
    
    func getById(_ momentId: String) -> rjMomentEntityModel? {
        if let moment = getPersistenceModelById(momentId) {
            return rjMomentEntityModel(moment)
        }
        return nil
    }
    
    private func getPersistenceModelById(_ momentId: String) -> rjMomentPersistenceModel? {
        let realm = rjRealmMgr.shared.defaultRealm
        if let moment = realm.object(ofType: rjMomentPersistenceModel.self, forPrimaryKey: momentId) {
            return moment
        }
        return nil
    }
    
    func getPrevious(_ momentModel: rjMomentEntityModel) -> rjMomentEntityModel? {
        let moments = all()
        if let momentIndex = moments.firstIndex(of: momentModel) {
            let previousMomentIndex = momentIndex + 1
            if (previousMomentIndex < moments.count) {
                return moments[previousMomentIndex]
            }
        }
        
        return nil
    }
    
    func getNext(_ momentModel: rjMomentEntityModel) -> rjMomentEntityModel? {
        let moments = all()
        if let momentIndex = moments.firstIndex(of: momentModel) {
            let nextMomentIndex = momentIndex - 1
            if (nextMomentIndex >= 0) {
                return moments[nextMomentIndex]
            }
        }
        
        return nil
    }
    
    func getRandom() -> rjMomentEntityModel? {
        let moments = all()
        
        if moments.isEmpty {
            return nil
        }
        
        let randomIndex = rjCommon.getRandomInt(from: 0, to: moments.count-1)
        return moments[randomIndex]
    }
    
    func getBetween(from startDate: Date, to endDate: Date) -> [rjMomentEntityModel] {
        let realm = rjRealmMgr.shared.defaultRealm
        
        let predicate = NSPredicate(format: "when >= %d and when <= %d", Int(startDate.timeIntervalSince1970), Int(endDate.timeIntervalSince1970))
        
        return realm.objects(rjMomentPersistenceModel.self).filter(predicate).map { rjMomentEntityModel($0) }
    }
    
    func all() -> Array<rjMomentEntityModel> {
        let realm = rjRealmMgr.shared.defaultRealm
        let sort = [SortDescriptor(keyPath: "when", ascending: false), SortDescriptor(keyPath: "momentId", ascending: true)]
        
        return Array(realm.objects(rjMomentPersistenceModel.self).sorted(by:sort).map { rjMomentEntityModel($0) })
    }
    
    @discardableResult
    func delete(_ momentId: String) -> Bool {
        let realm = rjRealmMgr.shared.defaultRealm
        
        guard let moment = getPersistenceModelById(momentId) else {
            return false
        }
        
        try! realm.write {
            realm.delete(moment)
        }
        
        return true
    }
    
    @discardableResult
    func update(_ momentModel: rjMomentEntityModel) -> Bool {
        guard let moment = self.getPersistenceModelById(momentModel.id) else {
            return false
        }
        
        let realm = rjRealmMgr.shared.defaultRealm
        try! realm.write {
            moment.populate(momentModel, updateId: false)
        }
        return true
    }
    
    var isEmpty: Bool {
        let realm = rjRealmMgr.shared.defaultRealm
        return realm.objects(rjMomentPersistenceModel.self).isEmpty
    }
    
    func notifyMomentsUpdated() {
        NotificationCenter.default.post(name: .momentsUpdated, object: nil)
    }
}
