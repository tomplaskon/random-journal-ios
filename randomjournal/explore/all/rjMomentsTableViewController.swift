//
//  rjMomentsViewController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-07.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjMomentsTableViewController: UITableViewController {
    let momentsViewModel = rjMomentsViewModel()
    let momentCellIdentifier = "momentcell"
    let emptyCellIdentifier = "emptystate"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenForMomentUpdates()
        configureTable()
        
        momentsViewModel.start()
        bindModels()
    }
    
    func configureTable() {
        registerMomentCellType()
        tableView.rowHeight = 88
    }
    
    func bindModels() {
        // bind cell view models to table
        momentsViewModel.momentCellViewModels.bind(to: tableView) { [momentCellIdentifier, emptyCellIdentifier] dataSource, indexPath, tableView in
            
            switch dataSource[indexPath.row] {
            case .moment(let moment):
                let cell = tableView.dequeueReusableCell(withIdentifier: momentCellIdentifier, for: indexPath)
                if let cell = cell as? rjMomentTableViewCell {
                    cell.setup(viewModel: moment)
                }
                return cell
            case .empty():
                return tableView.dequeueReusableCell(withIdentifier: emptyCellIdentifier, for: indexPath)
            }

        }
        
        // watch for details
        _ = momentsViewModel.momentToViewDetails.observeNext { [weak self] moment in
            if moment != nil {
                self?.performSegue(withIdentifier: "viewmoment", sender: nil)
            }
        }
    }
    
    func listenForMomentUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(momentsUpdated), name: .momentsUpdated, object: nil)
    }
    
    @objc func momentsUpdated() {
        momentsViewModel.update()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .momentsUpdated, object: nil)
    }
    
    func registerMomentCellType() {
        let momentCellNib = UINib.init(nibName: "rjMomentTableViewCell", bundle: nil)
        self.tableView.register(momentCellNib, forCellReuseIdentifier: momentCellIdentifier)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        momentsViewModel.tappedMoment(index: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            if segueId == "viewmoment" {
                if let momentPageVC = segue.destination as? rjMomentPageViewController, let moment = momentsViewModel.momentToViewDetails.value {
                    momentPageVC.startingMoment = moment
                }
            }
        }
    }
}
