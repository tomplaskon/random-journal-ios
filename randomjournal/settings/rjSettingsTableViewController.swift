//
//  rjSettingsTableViewController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-08.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjSettingsTableViewController: UITableViewController {
    let NumberOfAlertsTitleIndex = 0;
    let NumberOfAlertsInputIndex = 1;
    let AlertStartTimeTitleIndex = 2;
    let AlertEndTimeTitleIndex = 4;
    let ScheduleAlertsButtonIndex = 1;
    let ShowRemindersButtonIndex = 2;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case NumberOfAlertsTitleIndex:
            return makeTitleCell(tableView: tableView, indexPath: indexPath, title: "Settings")
        case ScheduleAlertsButtonIndex:
            return makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: getReminderStatusBtnText(), btnAction: #selector(handleRemindersStatus))
        case ShowRemindersButtonIndex:
            return makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: "Show Reminder Schedule", btnAction: #selector(showReminderSchedule))
            
        default:
            return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        }
    }
    
    func getReminderStatusBtnText() -> String {
        return rjAppSettings().areRemindersEnabled() ? "Disable Reminders" : "Enable Reminders"
    }
    
    func makeTitleCell(tableView : UITableView, indexPath : IndexPath, title : String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "title", for: indexPath) as! rjSettingsTitleTableViewCell
        cell.lblTitle.text = title
        return cell
    }
    
    func makeNumberOfAlertsCell(tableView : UITableView, indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "numberinput", for: indexPath) as! rjSettingsNumberInputTableViewCell
        //cell.txtNumber
        return cell
    }
    
    func makeButtonCell(tableView : UITableView, indexPath : IndexPath, btnText : String, btnAction : Selector) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "button", for: indexPath) as! rjSettingsButtonTableViewCell
        cell.btnAction.setTitle(btnText, for: .normal)
        cell.btnAction.addTarget(self, action: btnAction, for: .touchUpInside)
        return cell;
    }
    
    @objc func handleRemindersStatus(sender : UIButton) {
        let scheduler = rjReminderScheduler()
        let settings = rjAppSettings()
        if (rjAppSettings().areRemindersEnabled()) {
            // toggling reminders off
            settings.setRemindersStatus(enabled: false)
            scheduler.clearReminders()
            
        } else {
            // toggling reminders on
            settings.setRemindersStatus(enabled: true)
            scheduler.updateReminders()
        }
        
        sender.setTitle(getReminderStatusBtnText(), for: .normal)
    }
    
    @objc func showReminderSchedule() {
        rjReminderScheduler().getCurrentScheduleReadable() { (scheduleStr) in
            let alert = UIAlertController(title: nil, message: scheduleStr, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
