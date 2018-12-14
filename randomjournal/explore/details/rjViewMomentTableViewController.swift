//
//  rjViewMomentTableViewController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-02.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjViewMomentTableViewController: UITableViewController {
    let dateTitleCellIndex = 0
    let dateContentCellIndex = 1
    let detailsTitleCellIndex = 2
    let detailsContentCellIndex = 3
    let spacerCellIndex  = 4
    let editButtonCellIndex = 5
    let deleteButtonCellIndex = 6
    
    var moment : rjMomentViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        configureTable()
        
        rjCommon.registerCommonTitleCell(tableView: tableView)
        rjCommon.registerCommonButtonCell(tableView: tableView)
    }

    func configureTable() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.allowsSelection = false
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case dateTitleCellIndex:
            return rjCommon.makeCommonTitleCell(tableView: tableView, cellForRowAt: indexPath, title: "Date")
        case dateContentCellIndex:
            return makeDateCell(tableView: tableView, cellForRowAt: indexPath, moment: self.moment)
        case detailsTitleCellIndex:
            return rjCommon.makeCommonTitleCell(tableView: tableView, cellForRowAt: indexPath, title: "Details")
        case detailsContentCellIndex:
            return makeDetailsCell(tableView: tableView, cellForRowAt: indexPath, moment: self.moment)
        case spacerCellIndex:
            return makeSpacerCell(tableView: tableView, cellForRowAt: indexPath)
        case editButtonCellIndex:
            return rjCommon.makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: "Edit", target: self, btnAction: #selector(editMoment))
        case deleteButtonCellIndex:
            return rjCommon.makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: "Delete", target: self, btnAction: #selector(confirmDeleteMoment))
        default:
            return tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        }
    }

    func makeDetailsCell(tableView: UITableView, cellForRowAt indexPath: IndexPath, moment: rjMomentViewModel?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! rjViewMomentDetailsTableViewCell
        
        cell.lblDetails.text = moment?.details
        
        return cell
    }
    
    func makeDateCell(tableView: UITableView, cellForRowAt indexPath: IndexPath, moment: rjMomentViewModel?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! rjViewMomentDetailsTableViewCell
        
        cell.lblDetails.text = moment?.when.long
        
        return cell
    }
    
    func makeSpacerCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! rjViewMomentDetailsTableViewCell
        
        cell.lblDetails.text = "\n\n"
        
        return cell
    }
    
    @objc func confirmDeleteMoment() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this moment?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                self.deleteMoment()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteMoment() {
        let momentMgr = rjMomentMgr()
        if let mom = self.moment {
            momentMgr.deleteMoment(mom.id)
            self.navigationController?.popToRootViewController(animated: true);
            momentMgr.notifyMomentsUpdated()
        } else {
            // TODO: common oops message
        }
    }
    
    @objc func editMoment() {
        self.performSegue(withIdentifier: "editmoment", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editmoment") {
            if let editVC = segue.destination as? rjEditMomentTableViewController {
                editVC.moment = moment
            }
        }
    }
}
