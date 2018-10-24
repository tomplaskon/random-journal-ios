//
//  rjSettingsTableViewController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-09-08.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit
import MessageUI
import UserNotifications

class rjSettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    let numberOfAlertsTitleIndex = 0
    let scheduleAlertsButtonIndex = 1
    let showRemindersButtonIndex = 2
    let tutorialButtonIndex = 3
    let exportButtonIndex = 4
    let importButtonIndex = 5
    weak var btnReminderStatus : UIButton?
    let enableReminderText =  "Enable Reminders"
    let disableReminderText = "Disable Reminders"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        rjCommon.registerCommonTitleCell(tableView: tableView)
        rjCommon.registerCommonButtonCell(tableView: tableView)
        
        watchForAppEnteringForeground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateReminderStatusButtonText()
    }

    func watchForAppEnteringForeground() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(_:)), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc func willEnterForeground(_ notification : NSNotification) {
        updateReminderStatusButtonText()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateReminderStatusButtonText() {
        guard let button = btnReminderStatus else {return}
        
        UNUserNotificationCenter.current().getNotificationSettings { [unowned self] settings in
            let buttonText = settings.authorizationStatus == .authorized && settings.alertSetting == .enabled && rjAppSettings.shared.areRemindersEnabled() ? self.disableReminderText : self.enableReminderText

            DispatchQueue.main.async {
                button.setTitle(buttonText, for: .normal)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case numberOfAlertsTitleIndex:
            return rjCommon.makeCommonTitleCell(tableView: tableView, cellForRowAt: indexPath, title: "Settings")
        case scheduleAlertsButtonIndex:
            let cell = rjCommon.makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: self.disableReminderText, target: self, btnAction: #selector(reminderStatusPressed)) as! rjCommonButtonTableViewCell
            btnReminderStatus = cell.btnAction
            updateReminderStatusButtonText()
            return cell
        case showRemindersButtonIndex:
            return rjCommon.makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: "Reminder schedule", target: self, btnAction: #selector(showReminderSchedule))
        case tutorialButtonIndex:
            return rjCommon.makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: "Tutorial", target: self, btnAction: #selector(showTutorial))
        case exportButtonIndex:
            return rjCommon.makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: "Export CSV", target: self, btnAction: #selector(exportCSV))
        case importButtonIndex:
            return rjCommon.makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: "Import CSV", target: self, btnAction: #selector(importCSV))
            
            
        default:
            return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        }
    }
    
    func getReminderStatusBtnText() -> String {
        return rjAppSettings.shared.areRemindersEnabled() ? self.disableReminderText : self.enableReminderText
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
    
    @objc func reminderStatusPressed(sender : UIButton) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { [unowned self, unowned sender] (granted, error) in
            if (!granted) {
                DispatchQueue.main.async {
                    sender.setTitle(self.enableReminderText, for: .normal)
                    self.showEnableNotificationsMsg()
                }
                return
            }
            
            let scheduler = rjReminderScheduler.shared
            let settings = rjAppSettings.shared
            
            if (rjAppSettings.shared.areRemindersEnabled()) {
                // toggling reminders off
                settings.setRemindersStatus(enabled: false)
                scheduler.clearReminders()
            } else {
                // toggling reminders on
                settings.setRemindersStatus(enabled: true)
                scheduler.updateReminders()
            }
            
            DispatchQueue.main.async {
                sender.setTitle(self.getReminderStatusBtnText(), for: .normal)
            }
        }
    }
    
    func showEnableNotificationsMsg() {
        let alert = UIAlertController(title: nil, message: "To use reminders you need to enable notifications in Settings for Random Journal", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func showReminderSchedule() {
        rjReminderScheduler.shared.getCurrentScheduleReadable() { (scheduleStr) in
            let alert = UIAlertController(title: nil, message: scheduleStr, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @objc func showTutorial() {
        let tutorialViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rjTutorialViewController")
        self.present(tutorialViewController, animated: true, completion: nil)
    }
    
    @objc func exportCSV() {
        if let fileURL = rjMomentExporter().exportMomentsToFile() {
            self.sendEmailWithCSVFile(fileURL)
        }
    }
    
    func sendEmailWithCSVFile(_ fileURL: URL) {
        let subject = "Random Journal Export"
        let body = "Here is your Random Journal Export data. Enjoy!"
        
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setSubject(subject)
            mailComposer.setMessageBody(body, isHTML: false)
            
            if let fileData = try? Data(contentsOf: fileURL) {
                mailComposer.addAttachmentData(fileData, mimeType: "text/csv", fileName: fileURL.lastPathComponent)
            }
            
            self.present(mailComposer, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ didFinishWithcontroller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func importCSV() {
        self.performSegue(withIdentifier: "import", sender: self)
    }
}
