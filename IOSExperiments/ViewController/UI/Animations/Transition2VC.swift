//
//  TransitionVC.swift
//  IOSExperiments
//
//  Created by Andrew Ashurow on 16.09.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import UIKit
import iOSSharedViewTransition


class Transition2VC: UIViewController, ASFSharedViewTransitionDataSource {
    @IBOutlet weak var sharedButton: UIButton!
    
    func sharedView() -> UIView! {
        return sharedButton
    }
    
}