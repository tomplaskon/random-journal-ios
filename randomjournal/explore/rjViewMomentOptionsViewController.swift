//
//  rjViewMomentOptionsViewController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-20.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjViewMomentOptionsViewController: UIViewController {

    @IBOutlet weak var switchShuffle: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureShuffleSwitch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateShuffleSwitchState()
    }
    
    func configureShuffleSwitch() {
        switchShuffle.addTarget(self, action: #selector(shuffleSwitchChanged), for: .valueChanged)
        self.updateShuffleSwitchState()
    }
    
    func updateShuffleSwitchState() {
        switchShuffle.isOn = rjAppSettings.shared.shuffleMoments
    }
    
    @objc func shuffleSwitchChanged() {
        rjAppSettings.shared.shuffleMoments = switchShuffle.isOn
    }
}
