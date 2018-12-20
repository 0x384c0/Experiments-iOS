//
//  UITableViewWithDynamicHeaderView.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 22.01.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//

class UITableViewWithDynamicHeaderView:UITableView{
    override func layoutSubviews() {
        super.layoutSubviews()
        if let headerView = tableHeaderView,let subview = headerView.subviews.first {
            headerView.h = subview.h
        }
    }
    
}
