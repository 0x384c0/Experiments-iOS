//
//  VCWithRefreshControlInTable.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 25.12.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

protocol VCWithRefreshControlInTable:class {
    //MARK: UI
    weak var tableView: UITableView!{get set}
    var refreshControl:UIRefreshControl?{get set}
    //MARK: UI Actions
    func refreshControlDidSwipe()
    //MARK: others
    func hideLoading()
}
extension VCWithRefreshControlInTable where Self: UIViewController{
    func vcWithRefreshControlInTableSetup(){
        let refreshControl = RefreshControlWithHandler()
        refreshControl.attributedTitle = NSAttributedString(string: "REFRESHING".localized)
        refreshControl.addRefreshObserver {[weak self] _ in
            self?.refreshControlDidSwipe()
        }
        tableView.addSubview(refreshControl)
        
        refreshControl.textLabel?.textColor = refreshControl.tintColor
        self.refreshControl = refreshControl
    }
    func showLoading(){
        navigationItem.rightBarButtonItem?.isEnabled = false
        if let refreshControl = refreshControl{
            if !refreshControl.isRefreshing{
                tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y - refreshControl.frame.size.height), animated: true)
                if tableView.numberOfRows(inSection: 0) == 0{
                    tableView.tableHeaderView?.isHidden = true
                    tableView.tableFooterView?.isHidden = true
                }
                refreshControl.beginRefreshing()
                
                DispatchQueue.mainAfterMilisec(50){[weak refreshControl]_ in
                    for view in refreshControl?.subviews.first?.subviews ?? []{
                        if let label = view as? UILabel,
                            refreshControl?.isRefreshing ?? false,
                            label.alpha < 0.3{
                            label.alpha = 1
                        }
                    }
                }
            }
        } else {
            preconditionFailure("setupRefreshControl() must be called before showLoading()")
        }
    }
    func hideLoading(){
        navigationItem.rightBarButtonItem?.isEnabled = true
        tableView.tableHeaderView?.isHidden = false
        tableView.tableFooterView?.isHidden = false
        refreshControl?.endRefreshing()
    }
}
class RefreshControlWithHandler:UIRefreshControl{
    var handler:((UIRefreshControl) -> Swift.Void)?
    func addRefreshObserver(handler: @escaping ((UIRefreshControl) -> Swift.Void)){
        self.handler = handler
        addTarget(self, action: #selector(RefreshControlWithHandler.handleRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    func handleRefresh(_ refreshControl: UIRefreshControl){
        handler?(refreshControl)
    }
    var textLabel:UILabel?{
        for view in subviews.first?.subviews ?? []{
            if let label = view as? UILabel{
                return label
            }
        }
        return nil
    }
    
}



protocol VCWithRefreshControlInScrollView:class {//TODO: find way to get rid of duplicated code
    //MARK: UI
    weak var scrollView: UIScrollView!{get set}
    var refreshControl:UIRefreshControl?{get set}
    //MARK: UI Actions
    func refreshControlDidSwipe()
    //MARK: others
    func hideLoading()
}
extension VCWithRefreshControlInScrollView where Self: UIViewController{
    func setupRefreshControl(){
        let refreshControl = RefreshControlWithHandler()
        refreshControl.attributedTitle = NSAttributedString(string: "REFRESHING".localized)
        refreshControl.addRefreshObserver {[weak self] _ in
            self?.refreshControlDidSwipe()
        }
        scrollView.alwaysBounceVertical = true
        scrollView.addSubview(refreshControl)
        
        refreshControl.textLabel?.textColor = refreshControl.tintColor
        self.refreshControl = refreshControl
    }
    func showLoading(){
        navigationItem.rightBarButtonItem?.isEnabled = false
        if let refreshControl = refreshControl{
            if !refreshControl.isRefreshing{
                scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - refreshControl.frame.size.height), animated: true)
                refreshControl.beginRefreshing()
                
                DispatchQueue.mainAfterMilisec(50){[weak refreshControl]_ in
                    for view in refreshControl?.subviews.first?.subviews ?? []{
                        if let label = view as? UILabel,
                            refreshControl?.isRefreshing ?? false,
                            label.alpha < 0.3{
                            label.alpha = 1
                        }
                    }
                }
            }
            for view in scrollView.subviews {
                if !view.isKind(of: RefreshControlWithHandler.self){
                    view.isHidden = true
                }
            }
        } else {
            preconditionFailure("setupRefreshControl() must be called before showLoading()")
        }
    }
    func hideLoading(){
        navigationItem.rightBarButtonItem?.isEnabled = true
        refreshControl?.endRefreshing()
        for view in scrollView.subviews {
            if !view.isKind(of: RefreshControlWithHandler.self){
                view.isHidden = false
            }
        }
    }
}

