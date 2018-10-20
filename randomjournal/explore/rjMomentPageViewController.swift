//
//  rjMomentPageViewController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-20.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjMomentPageViewController: UIPageViewController {
    var startingMoment : rjMoment?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let moment = startingMoment {
            let firstVC = makeViewMomentTableViewController()
            firstVC.moment = moment
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        dataSource = self
    }
    
    func makeViewMomentTableViewController() -> rjViewMomentTableViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rjViewMomentTableViewController") as! rjViewMomentTableViewController
    }
}

extension rjMomentPageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let momentMgr = rjMomentMgr()
        if let currentVC = viewController as? rjViewMomentTableViewController, let currentMoment = currentVC.moment, let prevMoment = momentMgr.getNextMoment(currentMoment) {
            
            let prevMomentVC = makeViewMomentTableViewController()
            prevMomentVC.moment = prevMoment
            
            return prevMomentVC
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let momentMgr = rjMomentMgr()
        if let currentVC = viewController as? rjViewMomentTableViewController, let currentMoment = currentVC.moment, let nextMoment = momentMgr.getPreviousMoment(currentMoment) {
            let nextMomentVC = makeViewMomentTableViewController()
            nextMomentVC.moment = nextMoment
            
            return nextMomentVC
        }
        
        return nil
    }
}
