//
//  ActionButton.swift
//  Movers
//
//  Created by Andrew Ashurov on 12/17/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import UIKit

@IBDesignable
class ActionButton: UIButton {
    let UNACTIVE_BG_COLOR = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 1, alpha: 1)
    let UNACTIVE_TEXT_COLOR = #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.7607843137, alpha: 1)
    
    @IBInspectable var buttonColor:UIColor = Constants.COLOR_TINT{
        didSet{
            backgroundColor = buttonColor
        }
    }
    var isStyleActive:Bool = true{
        didSet{
            if isStyleActive{
                setTitleColor(UIColor.white, for: .normal)
                backgroundColor = buttonColor
            } else {
                setTitleColor(UNACTIVE_TEXT_COLOR, for: .normal)
                backgroundColor = UNACTIVE_BG_COLOR
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForInterfaceBuilder()
    }
    
    override func prepareForInterfaceBuilder(){
            backgroundColor = buttonColor
            layer.cornerRadius = 4
            clipsToBounds = true
            setTitleColor(UIColor.white, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
}
