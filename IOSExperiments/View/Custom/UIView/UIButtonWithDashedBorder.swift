//
//  UIButtonWithDashedBorder.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 16.01.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//

class UIButtonWithDashedBorder:UIButton{
    @IBInspectable var borderCornerRadius:CGFloat = 8
    @IBInspectable var borderColor:UIColor = Constants.COLOR_TINT
    @IBInspectable var borderWidth:CGFloat = 2
    @IBInspectable var dashWidth:Int = 6
    @IBInspectable var dashBreakWidth:Int = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBorder()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBorder()
    }
    let border = CAShapeLayer()
    func setupBorder(){
        titleLabel?.textAlignment = .center
        self.clipsToBounds = true
        self.layer.cornerRadius = borderCornerRadius
        border.fillColor = nil
        border.strokeColor = borderColor.cgColor
        border.lineWidth = borderWidth
        border.lineDashPattern = [NSNumber(integerLiteral:dashWidth),NSNumber(integerLiteral:dashBreakWidth),]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        border.removeFromSuperlayer()
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: borderCornerRadius).cgPath
        border.frame = bounds
        layer.addSublayer(border)
    }
}
