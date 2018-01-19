//
//  VCWithKeyboardProtocol.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 27.12.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import BABFrameObservingInputAccessoryView

protocol VCWithKeyboardProtocol: class {
    weak var bottomConstraint: NSLayoutConstraint! {get set}
    func keyboardWillShow(_ heigh:CGFloat)
    func keyboardWillHide()
    func getTextFileds() -> [UITextField]?
}

extension VCWithKeyboardProtocol where Self: UIViewController{
    func vcWithKeyboardProtocolSetup(){
        if let textFileds = getTextFileds() {
            for textFiled in textFileds{
                setupInteractiveDismissModeKeyboard(textFiled: textFiled)
            }
        } else {
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil){[weak self] notif in
                self?.keyboardWillShow(notif)
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil){[weak self] notif in
            self?.keyboardWillHide(notif)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillResignActive, object: nil, queue: nil){[weak self] notif in
            self?.dismissKeyboard()
        }
    }
    func keyboardWillShow(_ notification: Notification) {
        if isVCNotVisible{ return }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint.constant = keyboardSize.height
            keyboardWillShow(keyboardSize.height)
        }
    }
    func keyboardWillHide(_ notification: Notification) {
        if isVCNotVisible{ return }
        bottomConstraint.constant = 0
        keyboardWillHide()
    }
    func keyboardWillShow(_ heigh:CGFloat){}
    func keyboardWillHide(){}
    var isVCNotVisible:Bool{
        return navigationController?.topViewController ?? self != self || view.window == nil
    }
    
    //for UIScrollViewKeyboardDismissMode.interactive
    func getTextFileds() -> [UITextField]? {
        return nil
    }
    
    
    
    
    func setupInteractiveDismissModeKeyboard(textFiled:UITextField){
        let inputView = BABFrameObservingInputAccessoryView(frame: .zero)
        inputView.isUserInteractionEnabled = false
        textFiled.inputAccessoryView = inputView
        inputView.keyboardFrameChangedBlock = {[weak self] data in
            let viewHeigh = data.1.y,
            constaintValue = UIScreen.main.bounds.height - viewHeigh
            self?.bottomConstraint?.constant = constaintValue
        }
    }
}
