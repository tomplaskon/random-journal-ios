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
    let showRemindersButtonIndex = 1
    let tutorialButtonIndex = 2
    let exportButtonIndex = 3
    let importButtonIndex = 4
    let showReminderScheduleButtonIndex = 5
    weak var btnReminderStatus : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        rjCommon.registerCommonTitleCell(tableView: tableView)
        rjCommon.registerCommonButtonCell(tableView: tableView)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        case showRemindersButtonIndex:
            return rjCommon.makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: "Reminders", target: self, btnAction: #selector(reminderSettingsPressed))
        case tutorialButtonIndex:
            return rjCommon.makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: "Tutorial", target: self, btnAction: #selector(showTutorial))
        case exportButtonIndex:
            return rjCommon.makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: "Export CSV", target: self, btnAction: #selector(exportCSV))
        case importButtonIndex:
            return rjCommon.makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: "Import CSV", target: self, btnAction: #selector(importCSV))
        case showReminderScheduleButtonIndex:
            return rjCommon.makeButtonCell(tableView: tableView, indexPath: indexPath, btnText: "Show Reminder Schedule", target: self, btnAction: #selector(showReminderSchedule))
            
        default:
            return tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        }
    }
    
    func makeButtonCell(tableView : UITableView, indexPath : IndexPath, btnText : String, btnAction : Selector) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "button", for: indexPath) as! rjSettingsButtonTableViewCell
        cell.btnAction.setTitle(btnText, for: .normal)
        cell.btnAction.addTarget(self, action: btnAction, for: .touchUpInside)
        return cell
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
    
    @objc func reminderSettingsPressed() {
        self.performSegue(withIdentifier: "reminders", sender: self)
    }
}
