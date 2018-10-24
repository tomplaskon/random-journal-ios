//
//  rjTabBarController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-01.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (rjAppSettings.shared.shouldShowTutorial()) {
            performSegue(withIdentifier: "tutorial", sender: self)
        }
    }
}
