//
//  rjTutorialFinishViewController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-01.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit
import UserNotifications

class rjTutorialFinishViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func preAskForNotifications() {
        let alert = UIAlertController(title: "Reminder Notifications", message: "Random Journal uses notifications to help you capture moments.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Give permission", style: .default) { [unowned self] alert in
            self.askForNotifications()
        })
        alert.addAction(UIAlertAction(title: "Later", style: .cancel) { [unowned self] alert in
            self.finishTutorial()
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    func askForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if (!granted) {
                return
            }

            rjAppSettings.shared.setRemindersStatus(enabled: true)
            rjReminderScheduler.shared.updateReminders()
        }
        
        finishTutorial()
    }
    
    func finishTutorial() {
        rjAppSettings.shared.setTutorialComplete()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDonePressed(_ sender: Any) {
        self.preAskForNotifications()
    }
}
