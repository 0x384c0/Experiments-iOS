//
//  UITextFieldDelegateHidingKeyboard.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 23.01.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//


class UITextFieldDelegateHidingKeyboard:NSObject, UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class UITextFieldDelegateLimitedLength : UITextFieldDelegateHidingKeyboard{
    init(length:Int) {
        LENGTH = length
    }
    let LENGTH:Int
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let newStr = (text as NSString).replacingCharacters(in: range, with: string)
            let length = newStr.characters.count
            if length > LENGTH {
                return false
            }
        }
        return true
    }
}

class UITextFieldDelegateWithKBDismiss:NSObject, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class UITextFieldDelegateOnlyNumbers:NSObject, UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return Int(string) != nil
    }
}
