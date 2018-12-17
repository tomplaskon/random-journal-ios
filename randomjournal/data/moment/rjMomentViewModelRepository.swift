//
//  rjMomentMgr.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

class rjMomentViewModelRepository {

    let entityRepository = rjMomentEntityModelRepository.shared
    static let shared = rjMomentViewModelRepository()
    
    private init() { }
    
    @discardableResult
    func add(when: Date, details: String) -> String {
        return entityRepository.add(when: when, details: details)
    }
    
    func getById(_ momentId: String) -> rjMomentViewModel? {
        if let entityModel = entityRepository.getById(momentId) {
            return rjMomentViewModel(entityModel)
        }
        return nil
    }
    
    func getPrevious(_ viewModel: rjMomentViewModel) -> rjMomentViewModel? {
        if let entityModel = entityRepository.getPrevious(viewModel.entityModel) {
            return rjMomentViewModel(entityModel)
        }
        return nil
    }
    
    func getNext(_ viewModel: rjMomentViewModel) -> rjMomentViewModel? {
        if let entityModel = entityRepository.getNext(viewModel.entityModel) {
            return rjMomentViewModel(entityModel)
        }
        return nil
    }
    
    func getRandom() -> rjMomentViewModel? {
        if let entityModel = entityRepository.getRandom() {
            return rjMomentViewModel(entityModel)
        }
        return nil
    }
    
    func getBetween(from startDate: Date, to endDate: Date) -> [rjMomentViewModel] {
        return entityRepository.getBetween(from: startDate, to: endDate).map { rjMomentViewModel($0) }
    }
    
    func all() -> Array<rjMomentViewModel> {
        return entityRepository.all().map { rjMomentViewModel($0) }
    }
    
    @discardableResult
    func delete(_ momentId: String) -> Bool {
        return entityRepository.delete(momentId)
    }
    
    @discardableResult
    func update(_ viewModel: rjMomentViewModel) -> Bool {
        return entityRepository.update(viewModel.entityModel)
    }
    
    var isEmpty: Bool {
        return entityRepository.isEmpty
    }
    
    func notifyMomentsUpdated() {
        entityRepository.notifyMomentsUpdated()
    }
}
