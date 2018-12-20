//
//  UIAlertControllerWithTextField.swift
//  Movers
//
//  Created by Andrew Ashurov on 12/10/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import UIKit

class UIAlertControllerWithTextField : UIAlertController {
    deinit {
        Logger.logDeinit(self)
        if let observer = observer{
            NotificationCenter
                .default
                .removeObserver(observer)
        }
        
    }
    var observer:NSObjectProtocol?
    func addTextField(text:String?, placeholder:String?, keyboardType:UIKeyboardType = UIKeyboardType.default, textContentType:UITextContentType? = nil,spellChecker: @escaping (String?) -> Void){
        
        addTextField {[weak self] textField in
            
            textField.keyboardType = keyboardType
            if #available(iOS 10.0, *) {
                textField.textContentType = textContentType
            }
            
            textField.placeholder = placeholder
            textField.text = text
            
            textField.borderStyle = .roundedRect
            
            spellChecker(textField.text)
            
            self?.observer = NotificationCenter
                .default
                .addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { (notification) in
                    spellChecker(textField.text)
            }
        }
    }
    func present(from vc: UIViewController){
        vc.present(
            self,
            animated: true,
            completion: { [weak self] in
                self?.fixTextFields()
                self?.textFields?.first?.becomeFirstResponder()
            }
        )
    }
}



extension UIAlertController {
    //must call after presentViewController
    func fixTextFields(){
        for textField in textFields ?? [] {
            if let
                container = textField.superview,
                let effectView = container.superview?.subviews[0]
            {
                if (effectView.isKind(of: UIVisualEffectView.self) ){
                    container.backgroundColor = UIColor.clear
                    effectView.removeFromSuperview()
                }
            }
        }
    }
}
