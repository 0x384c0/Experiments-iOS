//
//  UITextViewLinkHelper.swift
//  0x384c0
//
//  Created by 0x384c0 on 12/16/19.
//  Copyright © 2019 0x384c0. All rights reserved.
//

import Foundation

//TODO: regex support
//TODO: multiple links and handlers support
class UITextViewLinkHelper : NSObject, UITextViewDelegate{
    
    private let url = URL(string: "http://custom_url.com")!
    private var handler:(() -> ())!
    init(
        textView:UITextView,
        searchText:String,
        searchOptions: NSString.CompareOptions,
        handler:@escaping () -> ()
        ) {
        super.init()
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        let text = attributedString.string
        if
            let range = text.range(of: searchText,options: searchOptions) {
            let nsRange = NSRange(range, in: text)
            attributedString.addAttributes([.link: url], range:nsRange)
            textView.attributedText = attributedString
            textView.delegate = self
            self.handler = handler
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL == url){
            handler()
            return false
        } else {
            return true
        }
    }
}
