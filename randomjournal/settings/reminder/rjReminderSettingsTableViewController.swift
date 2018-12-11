//
//  rjReminderSettingsTableViewController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-30.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit
import Bond

class rjReminderSettingsTableViewController: UITableViewController {

    var reminderSettingsViewModel = rjReminderSettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.delegate = self
        
        reminderSettingsViewModel.start()
        
        reminderSettingsViewModel.cellViewModels.bind(to: tableView) { dataSource, indexPath, tableView in
            
            let cellViewModel = dataSource[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier, for: indexPath)
            
            // dispose of any previous bindings
            cell.reactive.bag.dispose()
            
            // tell cell to configure itself
            if let cell = cell as? rjCellConfigurable {
                cell.setup(viewModel: cellViewModel)
            }
            
            // setup bindings for ReminderStatus cell
            if let cell = cell as? rjReminderStatusTableViewCell, let cellViewModel = cellViewModel as? rjReminderStatusCellViewModel {
                cellViewModel.remindersEnabled.bind(to: cell.swRemindersEnabled.reactive.isOn)

                cell.swRemindersEnabled.reactive.controlEvents(.touchUpInside).observeNext() { gesture in
                    cellViewModel.switchPressed()
                }
                .dispose(in: cell.reactive.bag)
                
                cellViewModel.errorMsg.observeNext() { [weak self] msg in
                    if !msg.isEmpty {
                        self?.showErrorMsg(msg)
                    }
                }
                .dispose(in: cell.reactive.bag)
            }
            
            // setup bindings for TimeSelect cells
            if let cell = cell as? rjTimeSelectTableViewCell, let cellViewModel = cellViewModel as? rjTimeSelectCellViewModel {
                cellViewModel.timeOffsetReadable.bind(to: cell.lblTime)
                    .dispose(in: cell.reactive.bag)
                cellViewModel.selectedTime.bidirectionalBind(to: cell.dpTime.reactive.date)
                    .dispose(in: cell.reactive.bag)
                
                cellViewModel.isExpanded.observeNext { [weak tableView, weak cell] isExpanded in
                    cell?.dpHeightConstraint.constant = isExpanded ? rjDateSelectTableViewCell.dpHeight : 0
                    tableView?.beginUpdates()
                    tableView?.endUpdates()
                }
                .dispose(in: cell.reactive.bag)
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = reminderSettingsViewModel.cellViewModels[indexPath.row]
        if let cellViewModel = cellViewModel as? rjCellViewModelPressable {
            cellViewModel.cellPressed?()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showErrorMsg(_ msg: String) {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
