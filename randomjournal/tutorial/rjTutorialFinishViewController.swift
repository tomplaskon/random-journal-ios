//
//  rjTutorialFinishViewController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-01.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit
import Bond

class rjTutorialFinishViewController: UIViewController {

    @IBOutlet var btnUseReminders: UIButton!
    @IBOutlet var btnGetStarted: UIButton!
    @IBOutlet var btnLater: UIButton!

    let tutorialFinishViewModel = rjTutorialFinishViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindModels()
    }
    
    func bindModels() {
        tutorialFinishViewModel.showUseReminderButton.map({ !$0 }).bind(to: btnUseReminders.reactive.isHidden)
        _ = btnUseReminders.reactive.tap.observeNext { [weak tutorialFinishViewModel] in
            tutorialFinishViewModel?.useReminderButtonTapped()
        }
        
        tutorialFinishViewModel.showLaterButton.map({ !$0 }).bind(to: btnLater.reactive.isHidden)
        _ = btnLater.reactive.tap.observeNext { [weak tutorialFinishViewModel] in
            tutorialFinishViewModel?.laterButtonTapped()
        }
        
        _ = tutorialFinishViewModel.showGetStartedButton.observeNext { [weak btnGetStarted] visible in
            if visible {
                btnGetStarted?.alpha = 0
                btnGetStarted?.isHidden = false
                UIView.animate(withDuration: 1.0) {
                    btnGetStarted?.alpha = 1
                }
            } else {
                btnGetStarted?.isHidden = true
            }
        }
        _ = btnGetStarted.reactive.tap.observeNext { [weak tutorialFinishViewModel] in
            tutorialFinishViewModel?.getStartedButtonTapped()
        }
        
        _ = tutorialFinishViewModel.tutorialFinished.observeNext { [weak self] finished in
            if finished {
                self?.finishTutorial()
            }
        }
    }
    
    func finishTutorial() {
        NotificationCenter.default.post(name: .selectAddMomentTab, object: nil)
        dismiss(animated: true, completion: nil)
    }
}
