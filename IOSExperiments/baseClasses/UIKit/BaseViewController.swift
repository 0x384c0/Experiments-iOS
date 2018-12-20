//
//  BaseViewController.swift
//  Movers
//
//  Created by Andrew Ashurov on 11/8/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD


class BaseViewController: UIViewController, BaseViewControllerProtocol {
    override var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.logViewDidLoad(self)
        setupNavBar()
        setEmptyBackButton()
    }
    
    var alertController: UIAlertController?
    let disposeBag = DisposeBag()
    func refresh(){}
    deinit {
        Logger.logDeinit(self)
    }
}

class BaseTableViewController: UITableViewController,BaseViewControllerProtocol {
    override var preferredStatusBarStyle: UIStatusBarStyle{return .lightContent}
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.logViewDidLoad(self)
        setupNavBar()
        setEmptyBackButton()
    }
    
    var alertController: UIAlertController?
    let disposeBag = DisposeBag()
    func refresh(){}
    deinit {
        Logger.logDeinit(self)
    }
}




protocol BaseViewControllerProtocol: class {
    func setEmptyBackButton()
    func setupNavBar()
    
    var disposeBag:DisposeBag {get}
    var alertController: UIAlertController? {get set}
    func showAlert(withError e:Error)
    func showAlert(withError e:Error, shouldRefresh:Bool, canGoBack:Bool)
    //for overriding
    func refresh()
    func showLoading()
    func hideLoading()
}

extension BaseViewControllerProtocol where Self: UIViewController{
    
    //MARK: Customizing TabBar
    internal func setEmptyBackButton(){
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        tabBarController?.navigationItem.backBarButtonItem = backItem
    }
    internal func setupNavBar(){
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = Constants.COLOR_TINT
        navigationController?.view.backgroundColor = Constants.COLOR_TINT
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barStyle = .black
    }
    
    func showAlert(withError e:Error){
        showAlert(withError: e, shouldRefresh: false, canGoBack: false)
    }
    func showAlert(withError e:Error, shouldRefresh:Bool, canGoBack:Bool){
        hideLoading()
        self.alertController?.dismiss(animated: false, completion: nil)
        let alertController = UIAlertController(title: "ERROR".localized,
                                                message: e.localizedDescription,
                                                preferredStyle: .alert)
        if shouldRefresh{
            alertController
                .addAction(UIAlertAction(title: "TRY_AGAIN".localized,
                                         style: UIAlertAction.Style.default,
                                         handler: {_ in
                                            self.refresh()
                }))
            if canGoBack{
                alertController
                    .addAction(UIAlertAction(title: "CLOSE".localized,
                                             style: UIAlertAction.Style.default,
                                             handler: {_ in
                                                self.dismissVC()
                    }))
            }
        } else {
            alertController
                .addAction(UIAlertAction(title: "CLOSE".localized,
                                         style: UIAlertAction.Style.default,
                                         handler: nil))
        }
        present(alertController, animated: true, completion: nil)
        self.alertController = alertController
    }
    
    
    
    func showLoading(){
        SVProgressHUD.show()
    }
    func hideLoading(){
        SVProgressHUD.dismiss()
    }
    
    fileprivate func dismissVC(){
        if let navVc = navigationController{
            navVc.popViewController(animated: true)
        } else{
            dismiss(animated: true, completion: nil)
        }
    }
}
