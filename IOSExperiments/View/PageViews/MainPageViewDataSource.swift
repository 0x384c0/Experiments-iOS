//
//  MainPageViewController.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 12/28/15.
//  Copyright © 2015 0x384c0. All rights reserved.
//

import UIKit

class MainPageViewDataSource: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var viewControllerParent :UIViewController?
    func setParentViewController(_ view:UIViewController){
        viewControllerParent = view
    }
    
    
    // Initialize it right away here
    var tabs = [MainTab]()
    
    
    func setTabs (_ tabs:[MainTab]){
        self.tabs = tabs        
        viewControllerParent?.navigationItem.title = tabs[0].title
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! MainPagerItem
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex - 1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! MainPagerItem
        if itemController.itemIndex + 1 < tabs.count {
            return getItemController(itemController.itemIndex + 1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (completed) {
            // .viewControllers[0] is always (in my case at least) the 'current' viewController.
            let vc = pageViewController.viewControllers![0]
            viewControllerParent?.navigationItem.title = vc.navigationItem.title
        }
    }
    
    func getItemController(_ itemIndex: Int) -> MainPagerItem? {
        
        if itemIndex < tabs.count {
            let pageItemController = viewControllerParent?.storyboard?.instantiateViewController(withIdentifier: "ItemControllerMain") as! MainPagerItem
            pageItemController.itemIndex = itemIndex
            pageItemController.mainTab = tabs[itemIndex]
            pageItemController.title = tabs[itemIndex].title
            //self.navigationItem.title = mainTabList.tabs[itemIndex].title
            return pageItemController
        }
        
        return nil
    }
    
    
    // MARK: - Page Indicator
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return tabs.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
