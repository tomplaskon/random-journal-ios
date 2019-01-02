//
//  rjExploreNavigationController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-12-21.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjExploreNavigationController: UINavigationController {

    override func loadView() {
        super.loadView()
        setViewControllers([rjMomentsViewController()], animated: false)
    }
}
