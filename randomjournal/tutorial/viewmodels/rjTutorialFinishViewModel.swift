//
//  rjTutorialFinishViewModel.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-14.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import Foundation
import UserNotifications
import Bond

class rjTutorialFinishViewModel {
    
    let showUseReminderButton = Observable(true)
    let showLaterButton = Observable(true)
    let showGetStartedButton = Observable(false)
    let tutorialFinished = Observable(false)
    
    private func askForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if (!granted) {
                return
            }
            
            rjAppSettings.shared.setRemindersStatus(enabled: true)
            rjReminderScheduler.shared.updateReminders()
        }
    }

    func useReminderButtonTapped() {
        showUseReminderButton.value = false
        showLaterButton.value = false
        showGetStartedButton.value = true
        
        askForNotifications()
    }
    
    func laterButtonTapped() {
        finishTutorial()
    }
    
    func getStartedButtonTapped() {
        finishTutorial()
    }
    
    private func finishTutorial() {
        rjAppSettings.shared.setTutorialComplete()
        tutorialFinished.value = true
    }
    
}
