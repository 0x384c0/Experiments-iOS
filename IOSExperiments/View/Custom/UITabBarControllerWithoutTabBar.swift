//
//  UITabBarControllerWithoutTabBar.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 02.12.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//



class UITabBarControllerWithoutTabBar: UITabBarController{
    var notifications = Notifications()
    var trueListOfChildViewControllers = [UIViewController]()
    private var firstSIdeMenuSetup = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        
        notifications.menuSelectedVC.subscribe{[weak self] item in
            self?.selectTab(vcClass: item)
        }
        fillListOfChildViewControllers()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstSIdeMenuSetup{
            (trueListOfChildViewControllers.first as? VCWithSideMenu)?.setupSideMenu()
            firstSIdeMenuSetup = false
        }
        tabBar.isHidden = true
        
        
        if let navVC = trueListOfChildViewControllers.first?.navigationController{
            moreNavigationController.navigationBar.isTranslucent    = navVC.navigationBar.isTranslucent
            moreNavigationController.navigationBar.barStyle         = navVC.navigationBar.barStyle
            moreNavigationController.navigationBar.tintColor        = navVC.navigationBar.tintColor
            moreNavigationController.navigationBar.barTintColor     = navVC.navigationBar.barTintColor
            moreNavigationController.navigationBar.backgroundColor  = navVC.navigationBar.backgroundColor
            moreNavigationController.navigationBar.shadowImage      = navVC.navigationBar.shadowImage
            moreNavigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        }
    }
    
    func fillListOfChildViewControllers(){
        for vc in (viewControllers ?? []){
            if let navVc = vc as? UINavigationController,
                let vc = navVc.viewControllers.first{
                trueListOfChildViewControllers.append(vc)
            } else {
                trueListOfChildViewControllers.append(vc)
            }
        }
    }
    
    func selectTab(item:Int){
        if
            item >= 0,
            item <= viewControllers!.count{
            selectedIndex = item
        }
    }
    func selectTab(vcClass:UIViewController.Type){
        for (index,vc) in trueListOfChildViewControllers.enumerated(){
            if vc.isKind(of: vcClass){
                (vc as? VCWithSideMenu)?.setupSideMenu()
                selectedIndex = index
                return
            }
        }
    }
}

class ViewBack: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        tabBarController?.navigationItem.backBarButtonItem = backItem
    }
}
