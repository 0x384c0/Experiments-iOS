//
//  TransitionVC.swift
//  IOSExperiments
//
//  Created by Andrew Ashurow on 16.09.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import UIKit
import iOSSharedViewTransition


class Transition1VC: UIViewController, ASFSharedViewTransitionDataSource {
    @IBOutlet weak var sharedButton: UIButton!
    
    func sharedView() -> UIView! {
        return sharedButton
    }
    
    override func viewDidLoad() {
        ASFSharedViewTransition
            .addWith(
                fromViewControllerClass: Transition1VC.self,
                toViewControllerClass: Transition2VC.self,
                with: navigationController!,
                withDuration: 1
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sharedButton.isHidden = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        sharedButton.isHidden = true
    }
    
    @IBAction func back(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
