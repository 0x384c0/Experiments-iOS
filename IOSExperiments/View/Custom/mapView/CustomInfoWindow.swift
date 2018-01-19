//
//  CustomInfoWindow.swift
//  GoogleMapSwift
//
//  Created by Ziyang Tan on 4/6/15.
//  Copyright (c) 2015 Ziyang Tan. All rights reserved.
//

import UIKit

class CustomInfoWindow: UIView {
    static var customReuseIdentifier:String{return className}
    //MARK: UI
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var phoneTextView: UITextView!
    
    @IBAction func phoneTap(_ sender: UIButton) {
        print(#function)
    }
    @IBAction func urlTap(_ sender: Any) {
        print(#function)
    }
    //MARK: data
    func setup(title:String,phone:String){
        titleLabel.text = title
        phoneTextView.text = phone
    }
}
