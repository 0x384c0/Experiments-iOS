
//
//  BaseXibView.swift
//  findout
//
//  Created by 0x384c0 on 01.11.16.
//  Copyright © 2016 kilograpp. All rights reserved.
//

import UIKit

class BaseXibView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupView()
    }
    
    // Our custom view from the XIB file
    var view: UIView!
    func xibSetup() {
        view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    func setupView(){}
}
