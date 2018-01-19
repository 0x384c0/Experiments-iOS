//
//  CustomSectionView.swift
//  iosExperiments
//
//  Created by 0x384c0 on 2/5/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import UIKit

class CustomSectionView: UITableViewHeaderFooterView {
    static let
    customReuseIdentifier = "CustomSectionView",
    estimatedHeigh:CGFloat = 41,
    empty = "CustomSectionView.empty"
    @IBOutlet weak var titleLabelText: UILabel!
    @IBOutlet weak var textBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var customBackgroundView: UIView!
    
    func setText(_ text:String?,backgroundColor:UIColor? = nil){
        if let backgroundColor = backgroundColor{
            customBackgroundView.backgroundColor = backgroundColor
        }
        if text == CustomSectionView.empty{
            textBottomConstraint.priority = 1
            titleLabelText.text = ""
        } else {
            textBottomConstraint.priority = 999
            titleLabelText.text = text?.uppercased()
        }
    }
    static func addSelf(to tableView:UITableView){
        tableView.estimatedSectionHeaderHeight = CustomSectionView.estimatedHeigh
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.sectionFooterHeight = 0
        tableView.register(
            UINib(nibName: CustomSectionView.customReuseIdentifier, bundle: nil),
            forHeaderFooterViewReuseIdentifier: CustomSectionView.customReuseIdentifier
        )
    }
}
