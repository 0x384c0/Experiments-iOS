//
//  UISearchBar.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 09.02.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//



private struct AssociatedKeys {
    static var
    fieldTintAssociationKey     = "customKey.fieldTintAssociation",
    refreshIndicatorInBarKey    = "customKey.refreshIndicatorInBar"
}

extension UISearchBar{
    fileprivate var fieldTintColor:UIColor {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.fieldTintAssociationKey) as? UIColor ?? tintColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.fieldTintAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    fileprivate var searchBarActivityIndicator:UIActivityIndicatorView {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.refreshIndicatorInBarKey) as? UIActivityIndicatorView ?? UIActivityIndicatorView()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.refreshIndicatorInBarKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var textField:UITextField? {
        get {
            return value(forKey: "searchField") as? UITextField
        }
    }
    func setFieldTextColor(_ color:UIColor) -> UISearchBar{
        textField?.textColor = color
        return self
    }
    func setFieldTintColor(_ color:UIColor) -> UISearchBar{
        //Tinting search icon
        let textFieldInsideSearchBar = textField
        let iconView = textFieldInsideSearchBar?.leftView as? UIImageView
        iconView?.image = iconView?.image?.withRenderingMode(.alwaysTemplate)
        iconView?.tintColor = color
        
        //Tinting clear icon
        let clearButton = textFieldInsideSearchBar?.value(forKey: "clearButton") as? UIButton
        let clearImage = clearButton?.imageView?.image
        setImage(
            clearImage?.getTintedImage(color),
            for: UISearchBarIcon.clear,
            state: UIControlState()
        )
        fieldTintColor = color
        
        //Tinting UIActivityIndicatorView
        
        searchBarActivityIndicator = UIActivityIndicatorView()
        
        searchBarActivityIndicator.hidesWhenStopped = true
        searchBarActivityIndicator.color = color
        searchBarActivityIndicator.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        textFieldInsideSearchBar?.addSubview(searchBarActivityIndicator)
        return self
    }
    
    func setFieldPlaceHolderTintedText(_ text:String) -> UISearchBar{
        //Tinting placeholder
        let attributeDict = [NSForegroundColorAttributeName: fieldTintColor]
        textField?.attributedPlaceholder = NSAttributedString(string: text, attributes: attributeDict)
        
        return self
    }
    func setCancelText(_ text:String) -> UISearchBar{
        setValue(text, forKey:"_cancelButtonText")
        return self
    }
    
    func stopAnimatingIndicator(){
        searchBarActivityIndicator.stopAnimating()
    }
    func startAnimatingIndicator(){
        searchBarActivityIndicator.startAnimating()
    }
}
