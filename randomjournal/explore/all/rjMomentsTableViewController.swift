//
//  rjMomentsViewController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-07.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjMomentsTableViewController: UITableViewController {
    var momentsViewModel: rjMomentsViewModelProtocol? {
        willSet(nextViewModel) {
            if let _ = momentsViewModel {
                unbindViewModel()
            }
        }
        
        didSet {
            if let viewModel = momentsViewModel {
                bindViewModel(viewModel)
            }
        }
    }
    let momentCellIdentifier = "momentcell"
    let emptyCellIdentifier = "emptystate"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenForMomentUpdates()
        configureTable()
        momentsViewModel = rjMomentsViewModel()
    }
    
    fileprivate func configureTable() {
        registerMomentCellType()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 89
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func bindViewModel(_ viewModel: rjMomentsViewModelProtocol) {
        viewModel.start()
        
        // bind cell view models to table
        viewModel.momentCellViewModels.bind(to: tableView) { [momentCellIdentifier, emptyCellIdentifier] dataSource, indexPath, tableView in
            
            switch dataSource[indexPath.row] {
            case .moment(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: momentCellIdentifier, for: indexPath) as! rjMomentTableViewCell
                cell.setup(viewModel: viewModel)
                return cell
            case .summaryGraph(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: rjMomentSummaryGraphTableViewCell.cellIdentifier, for: indexPath) as! rjMomentSummaryGraphTableViewCell
                cell.gvSummary.summaryViewModel = viewModel.summaryViewModel
                return cell
            case .empty():
                return tableView.dequeueReusableCell(withIdentifier: emptyCellIdentifier, for: indexPath)
            }
        }.dispose(in: self.reactive.bag)
        
        // watch for details
        viewModel.momentToViewDetails.observeNext { [weak self] moment in
            if moment != nil {
                self?.performSegue(withIdentifier: "viewmoment", sender: nil)
            }
        }.dispose(in: self.reactive.bag)
    }
    
    fileprivate func unbindViewModel() {
        if let _ = momentsViewModel {
            self.reactive.bag.dispose()
        }
    }
    
    fileprivate func listenForMomentUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(momentsUpdated), name: .momentsUpdated, object: nil)
    }
    
    @objc func momentsUpdated() {
        if let viewModel = momentsViewModel {
            viewModel.update()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .momentsUpdated, object: nil)
    }
    
    fileprivate func registerMomentCellType() {
        let momentCellNib = UINib.init(nibName: "rjMomentTableViewCell", bundle: nil)
        self.tableView.register(momentCellNib, forCellReuseIdentifier: momentCellIdentifier)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = momentsViewModel {
            viewModel.tappedCell(index: indexPath.row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            if segueId == "viewmoment" {
                if let viewModel = momentsViewModel, let momentPageVC = segue.destination as? rjMomentPageViewController, let moment = viewModel.momentToViewDetails.value {
                    momentPageVC.startingMoment = moment
                }
            }
        }
    }
}
