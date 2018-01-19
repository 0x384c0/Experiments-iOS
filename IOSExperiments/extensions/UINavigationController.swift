//
//  UINavigationController.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 03.03.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//

extension UINavigationController{
    func removeViewControllers(_ viewControllerClasses:[AnyClass]){
        let vcArray = viewControllers.filter{ vc in
            for vcClass in viewControllerClasses{
                if vc.isKind(of: vcClass){
                    return false
                }
            }
            return true
        }
        viewControllers = vcArray
    }
}
