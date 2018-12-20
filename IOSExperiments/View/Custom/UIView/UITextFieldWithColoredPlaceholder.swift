//
//  UITextFieldWithColoredPlaceholder.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 02.12.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//


class UITextFieldWithColoredPlaceholder: UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return nil
        }
        set {
            attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
