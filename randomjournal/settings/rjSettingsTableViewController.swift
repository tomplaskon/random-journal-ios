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
    let ScheduleAlertsButtonIndex = 1;
    let ShowRemindersButtonIndex = 2;
    let TutorialButtonIndex = 3;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rjCommon.registerCommonTitleCell(tableView: tableView)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case NumberOfAlertsTitleIndex:
            return rjCommon.makeCommonTitleCell(tableView: tableView, cellForRowAt: indexPath, title: "Settings")
        case ScheduleAlertsButtonIndex:
            return makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: getReminderStatusBtnText(), btnAction: #selector(handleRemindersStatus))
        case ShowRemindersButtonIndex:
            return makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: "Reminder Schedule", btnAction: #selector(showReminderSchedule))
        case TutorialButtonIndex:
            return makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: "Tutorial", btnAction: #selector(showTutorial))
            
        default:
            return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        }
    }
    
    func getReminderStatusBtnText() -> String {
        return rjAppSettings().areRemindersEnabled() ? "Disable Reminders" : "Enable Reminders"
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
    
    @objc func showTutorial() {
        let tutorialViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rjTutorialViewController")
        self.present(tutorialViewController, animated: true, completion: nil)
        //self.performSegue(withIdentifier: "tutorial", sender: nil)
    }
}
