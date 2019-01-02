//
//  rjMoment.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class rjMomentPersistenceModel: Object {
    @objc dynamic var momentId = "" // the moment's id
    @objc dynamic var when = 0 // when did the moment take place (unix timestamp)
    @objc dynamic var details = "" // the text details describing the moment

    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    init(momentId: String, when: Int, details: String) {
        self.momentId = momentId
        self.when = when
        self.details = details
        
        super.init()
    }
    
    // make momentId the primary key
    override static func primaryKey() -> String? {
        return "momentId"
    }

    func populate(_ momentModel: rjMomentEntityModel, updateId: Bool = true) {
        if updateId {
            self.momentId = momentModel.id
        }
        self.when = momentModel.when.intValue
        self.details = momentModel.details
    }
}
