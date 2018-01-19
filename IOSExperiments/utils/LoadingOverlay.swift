//
//  LoadingOverlay.swift
//  iosExperiments
//
//  Created by 0x384c0 on 1/20/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import UIKit
import Foundation


open class LoadingOverlay{
    
    private let
    overlayView = UIViewWithLoadingOverlay(),
    activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
    var
    overlayIsShown = false,
    backgroundColor = Constants.COLOR_PRIMARY
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    open func showOverlay(_ view: UIView!) {
        if !overlayIsShown{
            if Thread.isMainThread {
                showOverlayInMain(view)
            } else {
                DispatchQueue.main.async{[weak self] in
                    self?.showOverlayInMain(view)
                }
            }
            overlayIsShown = true
        }
    }
    open func hideOverlayView(_ animated:Bool = true) {
        if overlayIsShown{
            if Thread.isMainThread {
                hideOverlayViewInMain(animated)
            } else {
                DispatchQueue.main.async{[weak self] in
                    self?.hideOverlayViewInMain(animated)
                }
            }
            overlayIsShown = false
        }
    }
    
    
    
    fileprivate func showOverlayInMain(_ view: UIView!) {
        overlayView.alpha = 1
        overlayView.frame = view.bounds
        activityIndicator.center = overlayView.center
        overlayView.backgroundColor = backgroundColor
        overlayView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(overlayView)
    }
    fileprivate func hideOverlayViewInMain(_ animated:Bool = true){
        activityIndicator.stopAnimating()
        
        if animated {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: UIViewAnimationOptions.curveEaseOut,
                animations: {[weak self] in
                    self?.overlayView.alpha = 0.0
                },
                completion: {[weak self]  bool in
                    self?.overlayView.removeFromSuperview()
                }
            )
        } else {
            overlayView.removeFromSuperview()
        }
    }
    
    func setup(_ settings:LoadingOverlaySettings){
        backgroundColor = settings.color
        activityIndicator.activityIndicatorViewStyle = settings.style
    }
    
    
    private class UIViewWithLoadingOverlay:UIView{
        override func layoutSubviews() {
            super.layoutSubviews()
            if let frame = superview?.bounds{
                self.frame = frame
            }
            subviews.first?.center = center
        }
    }
}

struct LoadingOverlaySettings{
    let
    color:UIColor,
    style:UIActivityIndicatorViewStyle
}


