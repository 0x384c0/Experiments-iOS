//
//  CustomTextField.swift
//  Movers
//
//  Created by Andrew Ashurov on 12/17/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import Foundation

@IBDesignable
class TextFieldView: BaseXibView {
    //MARK: UI
    @IBOutlet weak var textField: UITextField!
    
    //MARK: UI Actions
    @IBAction func viewTap(_ sender: Any) {
        becomeFirstResponder()
    }
    
    //MARK: params
    @IBInspectable
    var placeholder:String = "PLACEHOLDER"{
        didSet{
            textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
    }
    @IBInspectable
    var keyboardType:String?{
        didSet{
            switch keyboardType {
            case "asciiCapable":
                textField.keyboardType = .asciiCapable
                
            case "numbersAndPunctuation":
                textField.keyboardType = .numbersAndPunctuation
                
            case "URL":
                textField.keyboardType = .URL
                
            case "numberPad":
                textField.keyboardType = .numberPad
                
            case "phonePad":
                textField.keyboardType = .phonePad
                
            case "namePhonePad":
                textField.keyboardType = .namePhonePad
                
            case "emailAddress":
                textField.keyboardType = .emailAddress
                
            case "decimalPad":
                textField.keyboardType = .decimalPad
                
            case "twitter":
                textField.keyboardType = .twitter
                
            case "webSearch":
                textField.keyboardType = .webSearch
                
            case "asciiCapableNumberPad":
                if #available(iOS 10.0, *) {
                    textField.keyboardType = .asciiCapableNumberPad
                }
            default:
                textField.keyboardType = .default
            }
        }
    }
    @IBInspectable
    var textContentType:String?{
        didSet{
            if #available(iOS 10.0, *) {
                switch textContentType {
                    
                case "name":
                    textField.textContentType = .name
                    
                case "namePrefix":
                    textField.textContentType = .namePrefix
                    
                case "givenName":
                    textField.textContentType = .givenName
                    
                case "middleName":
                    textField.textContentType = .middleName
                    
                case "familyName":
                    textField.textContentType = .familyName
                    
                case "nameSuffix":
                    textField.textContentType = .nameSuffix
                    
                case "nickname":
                    textField.textContentType = .nickname
                    
                case "jobTitle":
                    textField.textContentType = .jobTitle
                    
                case "organizationName":
                    textField.textContentType = .organizationName
                    
                case "location":
                    textField.textContentType = .location
                    
                case "fullStreetAddress":
                    textField.textContentType = .fullStreetAddress
                    
                case "streetAddressLine1":
                    textField.textContentType = .streetAddressLine1
                    
                case "streetAddressLine2":
                    textField.textContentType = .streetAddressLine2
                    
                case "addressCity":
                    textField.textContentType = .addressCity
                    
                case "addressState":
                    textField.textContentType = .addressState
                    
                case "addressCityAndState":
                    textField.textContentType = .addressCityAndState
                    
                case "sublocality":
                    textField.textContentType = .sublocality
                    
                case "countryName":
                    textField.textContentType = .countryName
                    
                case "postalCode":
                    textField.textContentType = .postalCode
                    
                case "telephoneNumber":
                    textField.textContentType = .telephoneNumber
                    
                case "emailAddress":
                    textField.textContentType = .emailAddress
                    
                case "URL":
                    textField.textContentType = .URL
                    
                case "creditCardNumber":
                    textField.textContentType = .creditCardNumber
                    
                case "username":
                    if #available(iOS 11.0, *) {
                        textField.textContentType = .username
                    }
                case "password":
                    if #available(iOS 11.0, *) {
                        textField.textContentType = .password
                    }
                case "newPassword":
                    if #available(iOS 12.0, *) {
                        textField.textContentType = .newPassword
                    }
                case "oneTimeCode":
                    if #available(iOS 12.0, *) {
                        textField.textContentType = .oneTimeCode
                    }
                default:
                    textField.textContentType = nil
                }
            }
        }
    }
    @IBInspectable
    var returnKey:String?{
        didSet{
            switch returnKey {
                
            case "go":
                textField.returnKeyType = .go
                
            case "google":
                textField.returnKeyType = .google
                
            case "join":
                textField.returnKeyType = .join
                
            case "next":
                textField.returnKeyType = .next
                
            case "route":
                textField.returnKeyType = .route
                
            case "search":
                textField.returnKeyType = .search
                
            case "send":
                textField.returnKeyType = .send
                
            case "yahoo":
                textField.returnKeyType = .yahoo
                
            case "done":
                textField.returnKeyType = .done
                
            case "emergencyCall":
                textField.returnKeyType = .emergencyCall
                
            case "continue":
                textField.returnKeyType = .continue
                
            default:
                textField.returnKeyType = .default
            }
        }
    }
    @IBInspectable
    var autocapitalizationType:String?{
        didSet{
            switch autocapitalizationType {
            case "words":
                textField.autocapitalizationType = .words
            case "sentences":
                textField.autocapitalizationType = .sentences
            case "allCharacters":
                textField.autocapitalizationType = .allCharacters
            default:
                textField.autocapitalizationType = .none
            }
        }
    }
    
    //MARK: wrappers
    var text:String?{
        set{textField.text = newValue}
        get{return textField.text}
    }
    var delegate:UITextFieldDelegate?{
        set{textField.delegate = newValue}
        get{return textField.delegate}
    }
    func shakeIfEmpty() -> Bool{
        return textField.shakeIfEmpty()
    }
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
}


protocol TextFieldViewHolderProtocol:class {
    var textFieldView: TextFieldView!{get}
}
extension TextFieldViewHolderProtocol{
    //MARK: wrappers
    var textField: UITextField{ return textFieldView.textField }
    var text:String?{
        set{textFieldView.text = newValue}
        get{return textFieldView.text}
    }
    var delegate:UITextFieldDelegate?{
        set{textFieldView.delegate = newValue}
        get{return textFieldView.delegate}
    }
    func shakeIfEmpty() -> Bool{
        return textFieldView.shakeIfEmpty()
    }
}
