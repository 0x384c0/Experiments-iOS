//
//  UIAlertControllerWithTextField
//  
//
//  Created by 0x384c0 on 3/28/16.
//  Copyright © 2016 0x384c0. All rights reserved.
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
    func addTextField(text:String?, placeholder:String?, keyboardType:UIKeyboardType = UIKeyboardType.default, spellChecker: @escaping (String?) -> Void){
        
        addTextField {[weak self] textField in
            
            textField.keyboardType = keyboardType
            
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
    func present(vc: UIViewController){
        vc.present(
            self,
            animated: true,
            completion: { [weak self] in
                self?.fixTextFields()
                self?.textFields?[safe:0]?.becomeFirstResponder()
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


//usage
//func showForgetPassDialog(){
//    alertControllerWithField = TextFieldAlertController(
//        title               : "PASS_RESTORE_TITLE".localized,
//        message             : "PASS_RESTORE_MESSAGE".localized,
//        preferredStyle      : .alert
//    )
//    let loginAction = UIAlertAction(title: "SEND".localized, style: .default) {[weak self] _ in
//        let textField = self?.alertControllerWithField?.textFields?[safe:0]
//        self?.restorePassword(mail: textField?.text)
//    }
//    let cancelAction = UIAlertAction(title: "CANCEL".localized, style: .cancel)
//    
//    alertControllerWithField?.addAction(loginAction)
//    alertControllerWithField?.addAction(cancelAction)
//    
//    alertControllerWithField?.addTextField(
//        text: "",
//        placeholder: "example@gmail.com" ,
//        keyboardType:.emailAddress
//    ){ [weak loginAction] text in
//        loginAction?.isEnabled = text?.isEmail ?? false
//    }
//    alertControllerWithField?.present(vc: self)
//}
