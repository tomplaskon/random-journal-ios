//
//  rjMomentsViewModel.swift
//  randomjournalTests
//
//  Created by Tom Plaskon on 2018-12-19.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import XCTest

@testable import randomjournal

class rjMomentsViewModelTest: XCTestCase {

    func testEmptyState() {
        var momentRepo = generateMockEntityModelRepository()
        momentRepo.isEmptyResult = true
        
        let viewModel = rjMomentsViewModel(momentRepository: momentRepo)
        viewModel.start()

        XCTAssertEqual(viewModel.momentCellViewModels.count, 1)
        XCTAssertEqual(viewModel.momentCellViewModels[0], .empty())
    }
    
    func testOneMoment() {
        var momentRepo = generateMockEntityModelRepository()
        let moment = rjMomentEntityModel(
            id: "123abc",
            when: Date(timeIntervalSince1970: 1545245701),
            details: "some details"
        )
        momentRepo.allResult = [
            moment
        ]
        momentRepo.isEmptyResult = false
        
        let viewModel = rjMomentsViewModel(momentRepository: momentRepo)
        viewModel.start()
        
        XCTAssertEqual(viewModel.momentCellViewModels.count, 2)

        if case .summaryGraph(_) = viewModel.momentCellViewModels[0] {
        } else {
            XCTFail("The first cell view model was not a summary graph")
        }
        
        if case let .moment(momentViewModel) = viewModel.momentCellViewModels[1]  {
            XCTAssertEqual(momentViewModel.id, "123abc")
            XCTAssertEqual(momentViewModel.when.date, Date(timeIntervalSince1970: 1545245701))
            XCTAssertEqual(momentViewModel.details, "some details")
        } else {
            XCTFail("Second cell view model was not the expected moment")
        }
    }
    
    func testTapMoment() {
        var momentRepo = generateMockEntityModelRepository()
        let moment = rjMomentEntityModel(
            id: "123abc",
            when: Date(timeIntervalSince1970: 1545245701),
            details: "some details"
        )
        momentRepo.allResult = [
            moment
        ]
        
        let viewModel = rjMomentsViewModel(momentRepository: momentRepo)
        viewModel.start()

        // check that before we tap on any cell there is no moment details to view
        XCTAssertNil(viewModel.momentToViewDetails.value)

        // check we have the expected number of cells
        XCTAssertEqual(viewModel.momentCellViewModels.count, 2)

        // verify that the second cell is the expected moment
        if case let .moment(secondViewModel) = viewModel.momentCellViewModels[1] {
            XCTAssertEqual(secondViewModel.id, "123abc")
        } else {
            XCTFail("Second view model is not a moment")
        }
        
        // tap on the second view model
        viewModel.tappedCell(index: 1)
        
        // check that we are being directed toward the correct moment details
        if let momentDetails = viewModel.momentToViewDetails.value {
            XCTAssertEqual(momentDetails.id, "123abc")
            XCTAssertEqual(momentDetails.when.date,  Date(timeIntervalSince1970: 1545245701))
            XCTAssertEqual(momentDetails.details, "some details")
        } else {
            XCTFail("No moment details to view")
        }
        
    }
}
