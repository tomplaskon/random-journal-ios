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

    let settingsViewModel = rjSettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
        bindModels()
    }
    
    func configureTable() {
        rjCommon.registerCommonTitleCell(tableView: tableView)
        rjCommon.registerCommonButtonCell(tableView: tableView)
        
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
    }
    
    func bindModels() {
        settingsViewModel.start()
        
        settingsViewModel.cellViewModels.bind(to: tableView) { dataSource, indexPath, tableView in
            switch dataSource[indexPath.row] {
            case .title(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: rjCommonTitleTableViewCell.cellIdentifier, for: indexPath) as! rjCommonTitleTableViewCell
                cell.setup(viewModel: viewModel)
                return cell
                
            case .button(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: rjCommonButtonTableViewCell.cellIdentifier, for: indexPath) as! rjCommonButtonTableViewCell
                cell.setup(viewModel: viewModel)
                return cell
            }
        }
        
        _ = settingsViewModel.destination.observeNext() { [weak self] destination in
            if let destination = destination {
                self?.performSegue(withIdentifier: destination, sender: nil)
            }
        }
        
        _ = settingsViewModel.reminderSchedule.observeNext() { [weak self] schedule in
            if let schedule = schedule {
                self?.showMessage(schedule)
            }
        }
        
        _ = settingsViewModel.showTutorial.observeNext() { [weak self] showTutorial in
            if showTutorial {
                self?.showTutorial()
            }
        }
        
        _ = settingsViewModel.CSVExportViewModel.observeNext { [weak self] exportViewModel in
            if let exportViewModel = exportViewModel {
                self?.sendEmailWithCSVFile(exportViewModel)
            }
        }
    }
    
    func showMessage(_ msg: String) {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func showTutorial() {
        let tutorialViewController = UIStoryboard.init(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "tutorialcontainer")
        self.present(tutorialViewController, animated: true, completion: nil)
    }
    
    func sendEmailWithCSVFile(_ exportViewModel: rjCSVExportViewModel) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setSubject(exportViewModel.subject)
            mailComposer.setMessageBody(exportViewModel.body, isHTML: exportViewModel.isBodyHTML)
            
            mailComposer.addAttachmentData(exportViewModel.fileData, mimeType: exportViewModel.mimeType, fileName: exportViewModel.fileName)
            
            self.present(mailComposer, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ didFinishWithcontroller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
