//
//  CircleView.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 05.12.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

class CircleView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width/2
        clipsToBounds = true
    }
}
