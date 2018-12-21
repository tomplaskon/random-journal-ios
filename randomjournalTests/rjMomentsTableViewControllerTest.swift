//
//  rjMomentsTableViewController.swift
//  randomjournalTests
//
//  Created by Tom Plaskon on 2018-12-19.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import XCTest
import Bond

@testable import randomjournal

class rjMomentsTableViewControllerTest: XCTestCase {

    class rjMockMomentsViewModel: rjMomentsViewModelProtocol {
        var momentCellViewModels = MutableObservableArray<rjMomentsViewModel.rjCellViewModel>()
        var momentToViewDetails = Observable<rjMomentViewModel?>(nil)
        
        var nextMomentCellViewModels = [rjMomentsViewModel.rjCellViewModel]()
        var tappedCellResult: rjMomentViewModel?
        
        func start() {
            momentCellViewModels.replace(with: nextMomentCellViewModels)
        }
        
        func update() {
            momentCellViewModels.replace(with: nextMomentCellViewModels)
        }
        
        func tappedCell(index: Int) {
            momentToViewDetails.value = tappedCellResult
        }
    }
    
    func generateMomentsTableViewController() -> rjMomentsTableViewController {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rjMomentsTableViewController") as! rjMomentsTableViewController
        vc.loadViewIfNeeded()
        return vc
    }
    
    func generateMockMomentsViewModel() -> rjMockMomentsViewModel {
        return rjMockMomentsViewModel()
    }
    
    func testEmptyState() {
        let vc = generateMomentsTableViewController()
        let vm = generateMockMomentsViewModel()
        vm.nextMomentCellViewModels = [.empty()]
        vc.momentsViewModel = vm
        
        XCTAssertEqual(vc.tableView.numberOfRows(inSection: 0), 1)
        
        if let emptyCell = vc.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? rjEmptyStateTableViewCell {
            XCTAssertEqual(emptyCell.lblEmptyState.text, "No moments captured.")
        } else {
            XCTFail("First cell is not an empty state cell")
        }
    }
    
    func testMoment() {
        let vc = generateMomentsTableViewController()
        let vm = generateMockMomentsViewModel()
        vm.nextMomentCellViewModels = [
            .moment(rjMomentViewModel(
                id: "123abc",
                when: Date(timeIntervalSince1970: 1545319222),
                details: "Some details.",
                referenceDate: Date(timeIntervalSince1970: 1545319232)
            ))
        ]
        vc.momentsViewModel = vm
        
        XCTAssertEqual(vc.tableView.numberOfRows(inSection: 0), 1)

        if let momentCell = vc.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? rjMomentTableViewCell {
            XCTAssertEqual(momentCell.lblDate.text, "Today @ 10:20 AM")
            XCTAssertEqual(momentCell.lblDetails.text, "Some details.")
        } else {
            XCTFail("First cell is not a moment cell")
        }
    }
}
