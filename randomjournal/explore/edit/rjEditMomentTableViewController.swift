//
//  rjEditMomentTableViewController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-06.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjEditMomentTableViewController: UITableViewController {
    var moment: rjMomentViewModel?
    var editMomentViewModel = rjEditMomentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.delegate = self

        if let moment = moment {
            editMomentViewModel.start(moment: moment)
        }
        
        rjCommon.registerCommonTitleCell(tableView: tableView)
        rjCommon.registerCommonButtonCell(tableView: tableView)
        rjCommon.registerCommonSpacerCell(tableView: tableView)
        
        editMomentViewModel.cellViewModels.bind(to: tableView) { dataSource, indexPath, tableView in
            
            let cellViewModel = dataSource[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier, for: indexPath)
            
            // dispose of any previous bindings
            cell.reactive.bag.dispose()
            
            // tell cell to configure itself
            if let cell = cell as? rjCellConfigurable {
                cell.setup(viewModel: cellViewModel)
            }
            
            // setup bindings for Date cells
            if let cell = cell as? rjDateSelectTableViewCell, let cellViewModel = cellViewModel as? rjDateSelectCellViewModel {
                cellViewModel.dateReadable.bind(to: cell.lblDate)
                    .dispose(in: cell.reactive.bag)
                cellViewModel.selectedDate.bidirectionalBind(to: cell.dpDate.reactive.date)
                    .dispose(in: cell.reactive.bag)
                
                cellViewModel.isExpanded.observeNext { [weak tableView, weak cell] isExpanded in
                    cell?.dpHeightConstraint.constant = isExpanded ? rjDateSelectTableViewCell.dpHeight : 0
                    tableView?.beginUpdates()
                    tableView?.endUpdates()
                }
                .dispose(in: cell.reactive.bag)
            }
            
            if let cell = cell as? rjEditDetailsTableViewCell, let cellViewModel = cellViewModel as? rjEditDetailsViewModel {
                cellViewModel.details.bidirectionalBind(to: cell.txtDetails.reactive.text)
                    .dispose(in: cell.reactive.bag)
            }
            
            return cell
        }
        
        _ = editMomentViewModel.returnToRoot.observeNext() { [weak self] returnToRoot in
            if (returnToRoot) {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = editMomentViewModel.cellViewModels[indexPath.row]
        if let cellViewModel = cellViewModel as? rjCellViewModelPressable {
            cellViewModel.cellPressed?()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
