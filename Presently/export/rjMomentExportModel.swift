//
//  rjMomentExportModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-17.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

struct rjMomentExportModel: Equatable {
    let id: String
    let when: rjExportWhenDate
    let details: String
    
    struct rjExportWhenDate: Equatable {
        let date: Date
        
        var readable: String {
            return date.with(format: "YYYY-MM-dd HH:mm:ss")
        }
        
        var data: String {
            return String(date.intValue)
        }
    }
    
    init(_ entityModel: rjMomentEntityModel) {
        id = entityModel.id
        when = rjExportWhenDate(date: entityModel.when)
        details = entityModel.details
    }
    
    init(id: String, when: Date, details: String) {
        self.id = id
        self.when = rjExportWhenDate(date: when)
        self.details = details
    }
    
    var entityModel: rjMomentEntityModel {
        return rjMomentEntityModel(
            id: id,
            when: when.date,
            details: details
        )
    }
}
