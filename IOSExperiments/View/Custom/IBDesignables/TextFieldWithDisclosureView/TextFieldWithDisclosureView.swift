//
//  TextFieldWithDisclosureView.swift
//  Movers
//
//  Created by Andrew Ashurov on 12/18/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import Foundation

@IBDesignable
class TextFieldWithDisclosureView: BaseXibView, TextFieldViewHolderProtocol {
    @IBOutlet weak var textFieldView: TextFieldView!
    @IBOutlet weak var iconView: UIImageView!
    
    
    //TextFieldWithDisclosureView
    @IBInspectable
    var image:String?{
        didSet{
            iconView.image = UIImage(named: image ?? "")
        }
    }
    @IBInspectable
    var textViewUserInteractionEnabled: Bool = true{
        didSet{
            textFieldView.isUserInteractionEnabled = textViewUserInteractionEnabled
        }
    }
    
    //MARK: params
    @IBInspectable
    var placeholder:String {
        get{return textFieldView.placeholder}
        set{textFieldView.placeholder = newValue}
    }
    @IBInspectable
    var keyboardType:String?{
        get{return textFieldView.keyboardType}
        set{textFieldView.keyboardType = newValue}
    }
    @IBInspectable
    var textContentType:String?{
        get{return textFieldView.textContentType}
        set{textFieldView.textContentType = newValue}
    }
    @IBInspectable
    var returnKey:String?{
        get{return textFieldView.returnKey}
        set{textFieldView.returnKey = newValue}
    }
    @IBInspectable
    var autocapitalizationType:String?{
        get{return textFieldView.autocapitalizationType}
        set{textFieldView.autocapitalizationType = newValue}
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textFieldView.becomeFirstResponder()
    }
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textFieldView.resignFirstResponder()
    }
}
