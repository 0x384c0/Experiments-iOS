//
//  LineView.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 24.11.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import Foundation


class LineView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        set1pxHeigh()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        set1pxHeigh()
    }
    
    private let heigh:CGFloat = 1
    private func set1pxHeigh(){
        let calculatedHeigh = heigh / UIScreen.main.scale//enforces it to be a true 1 pixel line
        
        let heighConstr = getConstrant(.height)
        heighConstr.constant = calculatedHeigh
        
    }
}
