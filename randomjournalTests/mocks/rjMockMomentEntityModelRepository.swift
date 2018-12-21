//
//  rjBaseMockMomentEntityModelRepository.swift
//  randomjournalTests
//
//  Created by Tom Plaskon on 2018-12-19.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
@testable import randomjournal

struct rjMockMomentEntityModelRepository: rjMockMomentEntityModelRepositoryProtocol {
    var getBetweenResult: [rjMomentEntityModel] = []
    var allResult: [rjMomentEntityModel] = []
    var isEmptyResult = true
    var addResult = ""
    var importEntityResult = false
    var getByIdResult: rjMomentEntityModel? = nil
    var getPreviousResult: rjMomentEntityModel? = nil
    var getNextResult: rjMomentEntityModel? = nil
    var getRandomResult: rjMomentEntityModel? = nil
    var deleteResult = false
    var updateResult = false
    
    func getBetween(from startDate: Date, to endDate: Date) -> [rjMomentEntityModel] {
        return getBetweenResult
    }
    func all() -> Array<rjMomentEntityModel> {
        return allResult
    }
    
    var isEmpty: Bool { return isEmptyResult }
    
    @discardableResult func add(when: Date, details: String) -> String {
        return addResult
    }
    func importEntity(_ momentModel: rjMomentEntityModel) -> Bool {
        return importEntityResult
    }
    func getById(_ momentId: String) -> rjMomentEntityModel? {
        return getByIdResult
    }
    func getPrevious(_ momentModel: rjMomentEntityModel) -> rjMomentEntityModel? {
        return getPreviousResult
    }
    func getNext(_ momentModel: rjMomentEntityModel) -> rjMomentEntityModel? {
        return getNextResult
    }
    func getRandom() -> rjMomentEntityModel? {
        return getRandomResult
    }
    @discardableResult func delete(_ momentId: String) -> Bool {
        return deleteResult
    }
    @discardableResult func update(_ momentModel: rjMomentEntityModel) -> Bool {
        return updateResult
    }
    
    func notifyMomentsUpdated() { }
}
