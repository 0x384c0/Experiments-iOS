//
//  VCWithSideMenu.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 22.11.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//


protocol VCWithSideMenu: class  {
    func setupSideMenu()
}
extension VCWithSideMenu where Self:UIViewController{
    func VCWithSideMenuSetup(){
        if revealViewController() != nil{
            hidesBottomBarWhenPushed = true
            revealViewController().rearViewRevealWidth = Constants.SIDE_MENU_WIDTH
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            let barButton = navigationItem.leftBarButtonItem
            barButton?.isAccessibilityElement = true
            barButton?.accessibilityLabel = "menu_button"
            barButton?.accessibilityIdentifier = "menu_button"
            barButton?.target = self.revealViewController()
            barButton?.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().delegate = SWRevealSwipeDelegate.shared
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
}

class SWRevealSwipeDelegate: NSObject, SWRevealViewControllerDelegate{
    private override init() {}
    static let shared = SWRevealSwipeDelegate()
    
    let overlayView = UIView()
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        revealController.frontViewController.dismissKeyboard()
        
        if
            UIDevice.current.userInterfaceIdiom == .phone,
            let frontTabBarVc =  revealController.frontViewController as? UITabBarControllerWithoutTabBar,
            let frontView = (frontTabBarVc.trueListOfChildViewControllers[frontTabBarVc.selectedIndex]).view{
            if position == .right{
                overlayView.removeFromSuperview()
                overlayView.frame.size = frontView.frame.size
                frontView.addSubview(overlayView)
            } else {
                overlayView.removeFromSuperview()
            }
        }
    }
}

