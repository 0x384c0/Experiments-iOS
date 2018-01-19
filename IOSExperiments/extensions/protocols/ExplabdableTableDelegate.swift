//
//  ExplabdableTableDelegate.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 12.01.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//




protocol ExplabdableTableDelegate:class{
    var explandedIndexPath:IndexPath?  {get set}
    weak var tableView:UITableView? {get set}
}
extension ExplabdableTableDelegate{
    func resetExpanding(){
        explandedIndexPath = nil
    }
    func setupExpandedCell(tableView: UITableView, indexPath: IndexPath,cell: ExplandableCell){
        self.tableView = tableView
        cell.setupExpanding(delegate: self, indexPath: indexPath)
        checkForExplanding(cell: cell, indexPath: indexPath)
    }
    func explandCell(indexPath: IndexPath,cell: ExplandableCell) {
        var
        explandedCell:ExplandableCell?,
        needsUpdateTableView = false
        if let explandedIndexPath = explandedIndexPath{
            explandedCell = tableView?.cellForRow(at: explandedIndexPath) as? ExplandableCell
        }
        if let explandedCell = explandedCell{
            explandedCell.collapse()
            needsUpdateTableView = true
        }
        if explandedCell === cell{
            self.explandedIndexPath = nil
        } else {
            needsUpdateTableView = true
            cell.expland()
            self.explandedIndexPath = indexPath
        }
        if needsUpdateTableView{
            tableView?.beginUpdates()
            tableView?.endUpdates()
        }
    }
    func checkForExplanding(cell: ExplandableCell, indexPath: IndexPath){
        if indexPath == explandedIndexPath {
            cell.expland()
        } else {
            cell.collapse()
        }
    }
}
protocol ExplandableCell:class {
    weak var delegate:ExplabdableTableDelegate? {get set}
    var indexPath: IndexPath? {get set}
    func setupExpanding(delegate:ExplabdableTableDelegate,indexPath: IndexPath)
    func expland()
    func collapse()
}
extension ExplandableCell{
    func setupExpanding(delegate:ExplabdableTableDelegate,indexPath: IndexPath){
        self.delegate = delegate
        self.indexPath = indexPath
    }
    func explandTap(){
        if let delegate = delegate, let indexPath = indexPath{
            delegate.explandCell(indexPath: indexPath, cell: self)
        }
    }
}
