//
//  rjTutorialStartViewController.swift
//  Presently
//
//  Created by Tom Plaskon on 2019-01-11.
//  Copyright © 2019 Tom Plaskon. All rights reserved.
//

import UIKit

class rjTutorialStartViewController: UIViewController {
    
    @IBOutlet var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // use a nil-targeted action up the responder chain to handle this request
        btnNext.addTarget(nil, action: Selector(("nextPage")), for: .touchUpInside)
    }
}
