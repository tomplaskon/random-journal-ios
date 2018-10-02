//
//  rjMomentsViewController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-07.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjMomentsTableViewController: UITableViewController {

    var moments = rjMomentMgr().allMoments()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerMomentCellType()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (appDelegate.momentsUpdated) {
            self.reloadMomentsTable()
            appDelegate.momentsUpdated = false
        }
    }
    
    func reloadMomentsTable() {
        moments = rjMomentMgr().allMoments()
        tableView.reloadData()
    }
    
    func registerMomentCellType() {
        let momentCellNib = UINib.init(nibName: "rjMomentTableViewCell", bundle: nil)
        self.tableView.register(momentCellNib, forCellReuseIdentifier: "momentcell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(moments.count, 1)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (moments.count == 0) {
            // there are no moments, show the empty state
            return makeEmptyStateCell(tableView : tableView , indexPath : indexPath)
        }
        
        let moment = moments[indexPath.row]
        return makeMomentCell(tableView : tableView, indexPath: indexPath, moment: moment)
    }
    
    func makeMomentCell(tableView : UITableView, indexPath : IndexPath, moment : rjMoment) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "momentcell", for: indexPath) as! rjMomentTableViewCell
        
        let date = Date(timeIntervalSince1970: TimeInterval(moment.when))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        let dateString = dateFormatter.string(from: date)
        
        cell.lblDate.text = dateString
        
        cell.lblDetails.text = moment.details
        
        return cell;
    }
    
    func makeEmptyStateCell(tableView : UITableView, indexPath : IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "emptystate", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewmoment", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            if segueId == "viewmoment" {
                if let viewMomentVC = segue.destination as? rjViewMomentTableViewController {
                    let momentIndex = self.tableView.indexPathForSelectedRow!.row
                    let moment = moments[momentIndex]
                    viewMomentVC.moment = moment
                }
            }
        }
    }
}
