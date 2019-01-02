//
//  rjTestViewController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-21.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjMomentsViewController: UIViewController {
    var tableView: UITableView!
    
    let viewModel: rjMomentsViewModelProtocol
    let momentCellIdentifier = "momentcell"
    let emptyCellIdentifier = "emptystate"
    let estimatedRowHeight: CGFloat = 89
    
    init(viewModel: rjMomentsViewModelProtocol = rjMomentsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = rjMomentsViewModel()
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .momentsUpdated, object: nil)
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.white
        
        tableView = setupTableView(rootView: view)
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenForMomentUpdates()
        bindViewModel(viewModel)
    }
    
    fileprivate func setupTableView(rootView: UIView) -> UITableView {
        let tableView = UITableView(frame: rootView.frame)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.separatorInset = .zero
        
        // register cells
        registerMomentCellType(to: tableView)
        registerEmptyStateCellType(to: tableView)
        registerSummaryGraphCellType(to: tableView)

        // constraints
        tableView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor)
        tableView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor)
        tableView.topAnchor.constraint(equalTo: rootView.topAnchor)
        tableView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor)
        
        return tableView
    }
    
    fileprivate func registerMomentCellType(to tableView: UITableView) {
        let momentCellNib = UINib.init(nibName: "rjMomentTableViewCell", bundle: nil)
        tableView.register(momentCellNib, forCellReuseIdentifier: momentCellIdentifier)
    }
    
    fileprivate func registerEmptyStateCellType(to tableView: UITableView) {
        let emptyCellNib = UINib.init(nibName: "rjEmptyStateTableViewCell", bundle: nil)
        tableView.register(emptyCellNib, forCellReuseIdentifier: emptyCellIdentifier)
    }
    
    fileprivate func registerSummaryGraphCellType(to tableView: UITableView) {
        let emptyCellNib = UINib.init(nibName: "rjMomentSummaryGraphTableViewCell", bundle: nil)
        tableView.register(emptyCellNib, forCellReuseIdentifier: rjMomentSummaryGraphTableViewCell.cellIdentifier)
    }
    
    fileprivate func bindViewModel(_ viewModel: rjMomentsViewModelProtocol) {
        viewModel.start()
        
        // bind cell view models to table
        _ = viewModel.momentCellViewModels.bind(to: tableView) { [momentCellIdentifier, emptyCellIdentifier] dataSource, indexPath, tableView in
            
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
        }
        
        // watch for details
        _ = viewModel.momentToViewDetails.observeNext { [weak self] moment in
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rjMomentPageViewController")
            
            if let moment = moment, let vc = vc as? rjMomentPageViewController {
                vc.startingMoment = moment
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    fileprivate func listenForMomentUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(momentsUpdated), name: .momentsUpdated, object: nil)
    }
    
    @objc func momentsUpdated() {
        viewModel.update()
    }
}

extension rjMomentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tappedCell(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
