//
//  RotatingImageView.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 13.01.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//

class RotatingImageView: UIImageView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rotateView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        rotateView()
    }
    private func rotateView() {
        if layer.animation(forKey: "RotatingImageView.loadingIndicator") == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2
            rotationAnimation.duration = 2
            rotationAnimation.repeatCount = Float.infinity
            
            layer.add(rotationAnimation, forKey: "RotatingImageView.loadingIndicator")
        }
    }
}
