//
//  rjTabBarController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-01.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjTabBarController: UITabBarController {
    let momentsTabIndex = 0
    let addMomentTabIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startListeningForNotifications()
    }
    
    deinit {
        stopListeningForNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (rjAppSettings.shared.shouldShowTutorial()) {
            performSegue(withIdentifier: "tutorial", sender: self)
        }
    }
    
    func startListeningForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(selectMomentsTab), name: .selectMomentsTab, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectAddMomentTab), name: .selectAddMomentTab, object: nil)
    }
    
    @objc func selectMomentsTab() {
        selectedIndex = momentsTabIndex
    }
    
    @objc func selectAddMomentTab() {
        selectedIndex = addMomentTabIndex
    }
    
    func stopListeningForNotifications() {
        NotificationCenter.default.removeObserver(self, name: .selectMomentsTab, object: nil)
        NotificationCenter.default.removeObserver(self, name: .selectAddMomentTab, object: nil)
    }
}
