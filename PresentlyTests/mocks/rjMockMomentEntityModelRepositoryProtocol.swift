//
//  rjMockMomentEntityModelRepositoryProtocol.swift
//  randomjournalTests
//
//  Created by Tom Plaskon on 2018-12-19.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation

@testable import Presently

protocol rjMockMomentEntityModelRepositoryProtocol: rjMomentEntityModelRepositoryProtocol {
    var getBetweenResult: [rjMomentEntityModel] { get set }
    var allResult: [rjMomentEntityModel] { get set }
    var isEmptyResult: Bool { get set }
    var addResult: String { get set }
    var importEntityResult: Bool { get set }
    var getByIdResult: rjMomentEntityModel? { get set }
    var getPreviousResult: rjMomentEntityModel? { get set }
    var getNextResult: rjMomentEntityModel? { get set }
    var getRandomResult: rjMomentEntityModel? { get set }
    var deleteResult: Bool { get set }
    var updateResult: Bool { get set }
}
