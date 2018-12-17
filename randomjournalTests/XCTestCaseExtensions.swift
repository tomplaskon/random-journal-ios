//
//  XCTestCase.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import XCTest
@testable import randomjournal

extension XCTestCase {
    func generateTestMoment() -> rjMomentEntityModel {
        let repo = rjMomentEntityModelRepository.shared
        let details = "Test details " + String(rjCommon.unixTimestampMilliseconds())
        let when = Date()
        
        let momentId = repo.add(when: when, details: details)
        
        return repo.getById(momentId)!
    }
}
