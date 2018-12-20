//
//  CardView.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 16.01.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 7
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 5
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = _isShadowVisible ? shadowColor?.cgColor : UIColor.clear.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    private var _isShadowVisible = true
    var isShadowVisible:Bool{
        get{
            return _isShadowVisible
        }
        set{
            _isShadowVisible = newValue
            layer.shadowColor = _isShadowVisible ? shadowColor?.cgColor : UIColor.clear.cgColor
        }
    }
}
