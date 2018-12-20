//
//  BaseSectionTableDelegate.swift
//  iosExperiments
//
//  Created by 0x384c0 on 1/23/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import UIKit
class BaseSectionTableDelegate<T>: NSObject, UITableViewDataSource, UITableViewDelegate  {
    
    var
    sections:[Section<T>]?
    
    
    
    func getData(at indexPath: IndexPath) -> T?{
        return sections?[safe:(indexPath as NSIndexPath).section]?.data?[safe:(indexPath as NSIndexPath).row]
    }
    func getAdditionalData(at indexPath: IndexPath) -> AnyObject?{
        return sections?[safe:(indexPath as NSIndexPath).section]?.additionalData?[safe:(indexPath as NSIndexPath).row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections?[safe:section]?.data?.count ?? sections?[safe:section]?.additionalData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections?[safe:section]?.title?.localized
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        preconditionFailure("This method must be overridden")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func setZeroInset(_ tableView: UITableView, cell:UITableViewCell){
        cell.layoutMargins = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        if #available(iOS 9, *) {
            tableView.cellLayoutMarginsFollowReadableWidth = false
        }
    }
}

class Section<T> {
    var
    data: [T]?,
    title:String?,
    additionalData:[AnyObject]? // if cell from different sections uses different models
    
    init(){}
    
    init (title:String?,data: [T]?) {
        self.data = data
        self.title = title
    }
    init (title:String?,additionalData: [AnyObject]?) {
        self.additionalData = additionalData
        self.title = title
    }
}
