//
//  RoundedImageView.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 18.01.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//

class CircleImageView: UIImageView {
    @IBInspectable var customBackgroundColor:UIColor = Constants.COLOR_PRIMARY_DARK
    override func layoutSubviews() {
        backgroundColor = customBackgroundColor
        layer.cornerRadius = frame.size.width/2
        clipsToBounds = true
    }
}
