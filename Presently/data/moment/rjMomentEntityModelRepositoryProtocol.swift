//
//  rjMomentEntityModelRepositoryProtocol.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-19.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

protocol rjMomentEntityModelRepositoryProtocol {
    @discardableResult func add(when: Date, details: String) -> String
    func importEntity(_ momentModel: rjMomentEntityModel) -> Bool
    func getById(_ momentId: String) -> rjMomentEntityModel?
    func getPrevious(_ momentModel: rjMomentEntityModel) -> rjMomentEntityModel?
    func getNext(_ momentModel: rjMomentEntityModel) -> rjMomentEntityModel?
    func getRandom() -> rjMomentEntityModel?
    func getBetween(from startDate: Date, to endDate: Date) -> [rjMomentEntityModel]
    func all() -> Array<rjMomentEntityModel>
    @discardableResult func delete(_ momentId: String) -> Bool
    @discardableResult func update(_ momentModel: rjMomentEntityModel) -> Bool
    var isEmpty: Bool { get }
    func notifyMomentsUpdated()
}
