//
//  ViewController.swift
//  CircleTransition
//
//  Created by Rounak Jain on 23/10/14.
//  Copyright (c) 2014 Rounak Jain. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class AnimationsViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var visualEffectsView: UIVisualEffectView!
    @IBOutlet weak var imageVIew: UIImageView!
    
    @IBAction func close(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    var initialBackgroundColor :UIColor!
    override func viewDidLoad() {
        initialBackgroundColor = view.backgroundColor
    }
    
    @IBAction func circleTapped(_ sender:UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    deinit {
        print("deinit \(type(of: self))", terminator: "")
    }
    
    @IBAction func animate(_ sender: AnyObject) {
        button.shakeViewForTimes(3)
        UIView.animate(withDuration: 1, animations: { [unowned self] in
            self.visualEffectsView.bounds.origin.x = -self.visualEffectsView.frame.width * 0.8
            self.visualEffectsView.effect = UIBlurEffect(style: .dark)
            self.view.backgroundColor = UIColor.blue
            
            let
            scaleTransform = self.imageVIew.transform.scaledBy(x: 0.6, y: 0.3),
            rotateAndScaleTransform =  scaleTransform.rotated(by: 3.1415926/3)
            self.imageVIew.transform = rotateAndScaleTransform
        }) 
    }
    @IBAction func deAnimate(_ sender: AnyObject) {
        button.shake4Times()
        UIView.animate(withDuration: 1, animations: { [unowned self] in
            self.visualEffectsView.bounds.origin.x = 0
            self.visualEffectsView.effect = UIBlurEffect(style: .light)
            self.view.backgroundColor = self.initialBackgroundColor
            self.imageVIew.transform = CGAffineTransform.identity
        }) 
    }
}

extension AnimationsViewController : ViewControllerWithButton {
    func getButton() -> UIView {
        return button
    }
}
