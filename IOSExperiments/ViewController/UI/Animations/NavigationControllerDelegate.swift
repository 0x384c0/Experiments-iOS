//
//  NavigationControllerDelegate.swift
//  CircleTransition
//
//  Created by Rounak Jain on 23/10/14.
//  Copyright (c) 2014 Rounak Jain. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
  @IBOutlet weak var navigationController: UINavigationController?
  
  var
  interactionController: UIPercentDrivenInteractiveTransition?,
  panGesture : UIPanGestureRecognizer!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    panGesture = UIPanGestureRecognizer(target: self, action: #selector(NavigationControllerDelegate.panned(_:)))
  }
  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    if self.navigationController?.viewControllers.count > 1{
      self.navigationController!.view.addGestureRecognizer(panGesture)
    } else {
      self.navigationController!.view.removeGestureRecognizer(panGesture)
    }
  }  
  @IBAction func panned(_ gestureRecognizer: UIPanGestureRecognizer) {
    print("changed \(gestureRecognizer.translation(in: self.navigationController!.view).x)", terminator: "")
    switch gestureRecognizer.state {
    case .began:
      let translation = gestureRecognizer.translation(in: self.navigationController!.view).x
      if translation > 0 {
        self.interactionController = UIPercentDrivenInteractiveTransition()
        if self.navigationController?.viewControllers.count > 1 {
          _ = self.navigationController?.popViewController(animated: true)
        } else {
          self.navigationController?.topViewController!.performSegue(withIdentifier: "PushSegue", sender: nil)
        }
      }
    case .changed:
      let translation = gestureRecognizer.translation(in: self.navigationController!.view)
      let completionProgress = translation.x/self.navigationController!.view.bounds.width
      self.interactionController?.update(completionProgress)
    case .ended:
      if (gestureRecognizer.velocity(in: self.navigationController!.view).x > 0) {
        self.interactionController?.finish()
      } else {
        self.interactionController?.cancel()
      }
      self.interactionController = nil
      
    default:
      self.interactionController?.cancel()
      self.interactionController = nil
    }
  }
  
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CircleTransitionAnimator()
  }
  
  func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return self.interactionController
  }
}
