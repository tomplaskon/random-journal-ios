//
//  rjRealmMgr.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-05.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import RealmSwift

class rjRealmMgr {
    class rjRealmConfigurationFactory {
        let groupName = "group.com.tplaskon.randomjournal"
        let realmDBPath = "Library/Caches/default.realm"
        
        func makeRealmConfiguration() -> Realm.Configuration {
            var config = Realm.Configuration()
            
            // configure the database path to use an app group so that extensions (e.g., widget) can access the Realm data
            let fileURL = FileManager.default
                .containerURL(forSecurityApplicationGroupIdentifier: groupName)!
                .appendingPathComponent(realmDBPath)
            
            config.fileURL = fileURL
            
            return config
        }
    }
    
    
     static let shared = rjRealmMgr()
     private let configuration: Realm.Configuration
    
     private init() {
        configuration = rjRealmConfigurationFactory().makeRealmConfiguration()
     }
    
     var defaultRealm: Realm {
        return try! Realm(configuration: configuration)
     }
}

