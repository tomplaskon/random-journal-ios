//
//  rjTutorialViewController.swift
//  randomjournal
//
//  Created by Tom Plaskon on 2018-10-01.
//  Copyright © 2018 Tom Plaskon. All rights reserved.
//

import UIKit

class rjTutorialViewController: UIPageViewController {

    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        let proxy: UIPageControl = UIPageControl.appearance(whenContainedInInstancesOf:[rjTutorialViewController.self])
        proxy.pageIndicatorTintColor = .lightGray
        proxy.currentPageIndicatorTintColor = .rjGreen
        proxy.backgroundColor = UIColor.white
        
        pages = [
            UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "tutorial1"),
            UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier: "tutorial2"),
        ]
        
        dataSource = self;
        
        if let firstViewController = pages.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension rjTutorialViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let prevPageIndex = pageIndex-1
        
        if prevPageIndex < 0 {
            // no previous
            return nil;
        }
        
        return pages[prevPageIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageIndex = pages.index(of: viewController) else {
            return nil
        }

        let nextPageIndex = pageIndex+1
        
        if nextPageIndex >= pages.count {
            return nil
        }
        
        return pages[nextPageIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = pages.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
    @objc func nextPage() {
        if let currentVC = viewControllers?[0],
            let nextVC = dataSource?.pageViewController(self, viewControllerAfter: currentVC) {
            setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
}
