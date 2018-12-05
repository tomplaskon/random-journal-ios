//
//  TodayViewController.swift
//  todaywidget
//
//  Created by Tom Plaskon on 2018-12-04.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit
import NotificationCenter
import RealmSwift

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblDescription: UILabel!
    
    let todayViewModel = rjTodayViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModels()
        todayViewModel.start()
    }
    
    func bindViewModels() {
        _ = todayViewModel.moment.observeNext { [weak self] momentViewModel in
            if let momentViewModel = momentViewModel {
                self?.lblDate.text = momentViewModel.date
                self?.lblDescription.text = momentViewModel.details
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        todayViewModel.update()
    }
}
