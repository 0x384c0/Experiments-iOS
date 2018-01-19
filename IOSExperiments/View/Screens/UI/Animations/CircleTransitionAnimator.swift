//
//  CircleTransitionAnimator.swift
//  CircleTransition
//
//  Created by Rounak Jain on 23/10/14.
//  Copyright (c) 2014 Rounak Jain. All rights reserved.
//

import UIKit

class CircleTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
  
  weak var transitionContext: UIViewControllerContextTransitioning?
  
  fileprivate let TRANSITION_TIME:TimeInterval = 0.6
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return TRANSITION_TIME;
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    self.transitionContext = transitionContext
    
    let containerView = transitionContext.containerView
    let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! ViewControllerWithButton
    let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! ViewControllerWithButton
    let button = fromViewController.getButton()
    
    containerView.addSubview(toViewController.view)
    
    let circleMaskPathInitial = UIBezierPath(ovalIn: button.frame)
    let extremePoint = CGPoint(x: button.center.x - 0, y: button.center.y - toViewController.view.bounds.height)
    let radius = sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y)) * 1.5
    let circleMaskPathFinal = UIBezierPath(ovalIn: button.frame.insetBy(dx: -radius, dy: -radius))
   
    let maskLayer = CAShapeLayer()
    maskLayer.path = circleMaskPathFinal.cgPath
    toViewController.view.layer.mask = maskLayer
    
    let maskLayerAnimation = CABasicAnimation(keyPath: "path")
    maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
    maskLayerAnimation.toValue = circleMaskPathFinal.cgPath
    maskLayerAnimation.duration = transitionDuration(using: nil)
    maskLayerAnimation.delegate = self
    maskLayer.add(maskLayerAnimation, forKey: "path")
    
    /*
    toViewController.view.alpha = 0.0
    UIView.animateWithDuration(
      transitionDuration(nil),
      animations: {
        toViewController.view.alpha = 1.0
      },
      completion:{[unowned self] flag in
        print("complete")
        self.animationDidStop(CAAnimation(),finished: flag)
      }
    )
    */
    
    /*
    //NOT WORKING
    let maskLayer = CAShapeLayer()
    maskLayer.path = circleMaskPathInitial.CGPath
    toViewController.view.layer.mask = maskLayer
     
    UIView.animateWithDuration(
      transitionDuration(nil),
      animations: {
        maskLayer.path = circleMaskPathFinal.CGPath
        toViewController.view.layer.mask = maskLayer
      },
      completion:{[unowned self] flag in
        print("complete")
        self.animationDidStop(CAAnimation(),finished: flag)
      }
    )
 */
  }
  
   func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled)
    self.transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from)?.view.layer.mask = nil
  }
  
}




protocol ViewControllerWithButton  {
  var view: UIView! {get set}
  func getButton() -> UIView
}
