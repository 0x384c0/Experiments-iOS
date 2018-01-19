//
//  BaseTableVIewDelegate.swift
//  iosExperiments
//
//  Created by 0x384c0 on 1/23/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import UIKit
class BaseTableViewDelegate<T>: NSObject, UITableViewDataSource, UITableViewDelegate  {
    
    var
    dataArray:[T]?,
    onClickHandler: ((T) -> Void)?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = dataArray?.count ?? 0
        return numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        preconditionFailure("This method must be overridden")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = dataArray?[safe:(indexPath as NSIndexPath).row]{
            onClickHandler?(item)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    func getData(at indexPath: IndexPath) -> T?{
        return dataArray?[safe:indexPath.row]
    }
    
    func setData(_ data:[T]?){
        self.dataArray = data
    }
}

class BaseCollectionViewDelegate<T> : NSObject, UICollectionViewDataSource,UICollectionViewDelegate{
    
    var
    dataArray:[T]?,
    onClickHandler: ((T) -> Void)?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfRowsInSection = dataArray?.count ?? 0
        return numberOfRowsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        preconditionFailure("This method must be overridden")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataArray?[safe:(indexPath as NSIndexPath).row]{
            onClickHandler?(item)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    func getData(at indexPath: IndexPath) -> T?{
        return dataArray?[safe:indexPath.row]
    }
}



protocol TableViewDelegateWithPlaceholderCell {
    var numberOfItemsInDataSource:Int? { get } //nil - data was not loaded: 0 - no data, show placeholder
}
extension TableViewDelegateWithPlaceholderCell{
    var numberOfItemsInDataSourceOrPlaceholders:Int{
        if let count = numberOfItemsInDataSource{
            return count == 0 ? 1 : count
        } else {
            return 0
        }
    }
    func getPlaceHolderCell() -> UITableViewCell?{
        if numberOfItemsInDataSource == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "NO_DATA".localized
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.textAlignment = .center
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = UIColor.clear
            return cell
        }else {
            return nil
        }
    }
}
