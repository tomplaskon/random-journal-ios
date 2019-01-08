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
    var nextReminderView: rjNextReminderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
        reminderSettingsViewModel.start()
        bindModels()
    }
    
    private func bindModels() {
        func getReusableCell(tableView: UITableView, identifier: String, indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            
            // common cell setup goes here
            cell.reactive.bag.dispose()
            
            return cell
        }
        
        reminderSettingsViewModel.cellViewModels.bind(to: tableView) { [weak self] dataSource, indexPath, tableView in
            
            switch dataSource[indexPath.row] {
            case .reminderStatus(let viewModel):
                let cell = getReusableCell(tableView: tableView, identifier: rjReminderStatusTableViewCell.cellIdentifier, indexPath: indexPath) as! rjReminderStatusTableViewCell
                cell.setup(viewModel: viewModel)
                self?.bindReminderStatus(cell: cell, viewModel: viewModel)
                
                return cell
            case .timeSelect(let viewModel):
                let cell = getReusableCell(tableView: tableView, identifier: rjTimeSelectTableViewCell.cellIdentifier, indexPath: indexPath) as! rjTimeSelectTableViewCell
                cell.setup(viewModel: viewModel)
                self?.bindTimeSelect(cell: cell, viewModel: viewModel)
                
                return cell
            }
        }
        
        if let nextReminderView = nextReminderView {
            reminderSettingsViewModel.nextReminderAt.bind(to: nextReminderView.nextReminderAt)
        }
    }
    
    private func configureTable() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.delegate = self
        nextReminderView = makeTableFooterView()
        tableView.tableFooterView = nextReminderView
    }
    
    private func makeTableFooterView() -> rjNextReminderView {
        return rjNextReminderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
    }
    
    private func bindReminderStatus(cell: rjReminderStatusTableViewCell, viewModel: rjReminderStatusCellViewModel) {
        viewModel.remindersEnabled.bind(to: cell.swRemindersEnabled.reactive.isOn)
        
        cell.swRemindersEnabled.reactive.controlEvents(.touchUpInside).observeNext() { gesture in
            viewModel.switchPressed()
        }
        .dispose(in: cell.reactive.bag)
        
        viewModel.errorMsg.observeNext() { [weak self] msg in
            if !msg.isEmpty {
                self?.showErrorMsg(msg)
            }
        }
        .dispose(in: cell.reactive.bag)
    }
    
    private func bindTimeSelect(cell: rjTimeSelectTableViewCell, viewModel: rjTimeSelectCellViewModel) {
        viewModel.timeOffsetReadable.bind(to: cell.lblTime)
            .dispose(in: cell.reactive.bag)
        viewModel.selectedTime.bidirectionalBind(to: cell.dpTime.reactive.date)
            .dispose(in: cell.reactive.bag)
        
        viewModel.isExpanded.observeNext { [weak tableView, weak cell] isExpanded in
            cell?.dpHeightConstraint.constant = isExpanded ? rjDateSelectTableViewCell.dpHeight : 0
            tableView?.beginUpdates()
            tableView?.endUpdates()
        }
        .dispose(in: cell.reactive.bag)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reminderSettingsViewModel.tappedCell(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showErrorMsg(_ msg: String) {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
