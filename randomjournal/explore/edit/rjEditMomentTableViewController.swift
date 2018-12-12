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

        configureTable()
        bindModels()
    }
    
    func bindModels() {
        if let moment = moment {
            editMomentViewModel.start(moment: moment)
        }
        
        func getReusableCell(tableView: UITableView, identifier: String, indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            
            // common cell setup goes here
            cell.reactive.bag.dispose()
            
            return cell
        }
        
        editMomentViewModel.cellViewModels.bind(to: tableView) { [weak self] dataSource, indexPath, tableView in
            
            switch dataSource[indexPath.row] {
            case .title(let viewModel):
                let cell = getReusableCell(tableView: tableView, identifier: rjCommonTitleTableViewCell.cellIdentifier, indexPath: indexPath) as! rjCommonTitleTableViewCell
                cell.setup(viewModel: viewModel)
                return cell
                
            case .dateSelect(let viewModel):
                let cell = getReusableCell(tableView: tableView, identifier: rjDateSelectTableViewCell.cellIdentifier, indexPath: indexPath) as! rjDateSelectTableViewCell
                self?.bindDateSelectCell(cell: cell, viewModel: viewModel)
                cell.setup(viewModel: viewModel)
                return cell
                
            case .details(let viewModel):
                let cell = getReusableCell(tableView: tableView, identifier: rjEditDetailsTableViewCell.cellIdentifier, indexPath: indexPath) as! rjEditDetailsTableViewCell
                self?.bindEditDetailsCell(cell: cell, viewModel: viewModel)
                cell.setup(viewModel: viewModel)
                return cell
                
            case .spacer(_):
                let cell = getReusableCell(tableView: tableView, identifier: rjCommonSpacerTableViewCell.cellIdentifier, indexPath: indexPath) as! rjCommonSpacerTableViewCell
                return cell
                
            case .save(let viewModel):
                let cell = getReusableCell(tableView: tableView, identifier: rjCommonButtonTableViewCell.cellIdentifier, indexPath: indexPath) as! rjCommonButtonTableViewCell
                cell.setup(viewModel: viewModel)
                return cell
            }
        }
        
        _ = editMomentViewModel.returnToRoot.observeNext() { [weak self] returnToRoot in
            if (returnToRoot) {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    private func bindDateSelectCell(cell: rjDateSelectTableViewCell, viewModel: rjDateSelectCellViewModel) {
        viewModel.dateReadable.bind(to: cell.lblDate)
            .dispose(in: cell.reactive.bag)
        viewModel.selectedDate.bidirectionalBind(to: cell.dpDate.reactive.date)
            .dispose(in: cell.reactive.bag)
        
        viewModel.isExpanded.observeNext { [weak tableView, weak cell] isExpanded in
            cell?.dpHeightConstraint.constant = isExpanded ? rjDateSelectTableViewCell.dpHeight : 0
            tableView?.beginUpdates()
            tableView?.endUpdates()
        }
        .dispose(in: cell.reactive.bag)
    }
    
    private func bindEditDetailsCell(cell: rjEditDetailsTableViewCell, viewModel: rjEditDetailsCellViewModel) {
        viewModel.details.bidirectionalBind(to: cell.txtDetails.reactive.text)
            .dispose(in: cell.reactive.bag)
    }
    
    private func configureTable() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.delegate = self

        rjCommon.registerCommonTitleCell(tableView: tableView)
        rjCommon.registerCommonButtonCell(tableView: tableView)
        rjCommon.registerCommonSpacerCell(tableView: tableView)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = editMomentViewModel.cellViewModels[indexPath.row].viewModel
        if let cellViewModel = cellViewModel as? rjCellViewModelPressable {
            cellViewModel.cellPressed?()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
