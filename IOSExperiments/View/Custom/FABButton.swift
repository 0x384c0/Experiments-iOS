//
//  File.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 09.03.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//

class FABButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width/2
        clipsToBounds = true
        
        let
        shadowOffsetWidth = 0,
        shadowOffsetHeight = 2,
        shadowColor  = UIColor.black,
        shadowOpacity: Float = 0.3,
        shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}
