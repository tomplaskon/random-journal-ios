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
    let deleteButtonCellIndex = 5
    
    var moment : rjMoment?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        configureTable()
        
        rjCommon.registerCommonTitleCell(tableView: tableView)
        rjCommon.registerCommonButtonCell(tableView: tableView)
    }

    func configureTable() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
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
        case deleteButtonCellIndex:
            return rjCommon.makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: "Delete", target: self, btnAction: #selector(confirmDeleteMoment))
        default:
            return tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        }
    }

    func makeDetailsCell(tableView: UITableView, cellForRowAt indexPath: IndexPath, moment: rjMoment?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! rjViewMomentDetailsTableViewCell
        
        cell.lblDetails.text = moment?.details
        
        return cell
    }
    
    func makeDateCell(tableView: UITableView, cellForRowAt indexPath: IndexPath, moment: rjMoment?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! rjViewMomentDetailsTableViewCell
        
        cell.lblDetails.text = moment?.whenReadableLong()
        
        return cell
    }
    
    func makeSpacerCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! rjViewMomentDetailsTableViewCell
        
        cell.lblDetails.text = "\n\n"
        
        return cell
    }
    
    @objc func confirmDeleteMoment() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this moment?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
                self.deleteMoment()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteMoment() {
        let momentMgr = rjMomentMgr()
        if let mom = self.moment {
            momentMgr.deleteMoment(mom)
            self.navigationController?.popToRootViewController(animated: true);
            self.appDelegate.momentsUpdated = true
        } else {
            // TODO: common oops message
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
