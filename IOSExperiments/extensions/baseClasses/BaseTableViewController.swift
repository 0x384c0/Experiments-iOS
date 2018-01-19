//
//  BaseTableViewController.swift
//  iosExperiments
//
//  Created by 0x384c0 on 3/2/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import UIKit
import RxSwift

class BaseTableViewController: UITableViewController, BaseViewControllerProtocol {
    var tabBarSettings:TabBarSettings{return TabBarSettings(barStyle: .black, tintColor: Constants.COLOR_PRIMARY, barTintColor: Constants.COLOR_TINT, isTransparent: false)}
    var loadingOverlaySettings:LoadingOverlaySettings{return LoadingOverlaySettings(color:Constants.COLOR_PRIMARY,style:.gray)}
    //MARK: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        handleViewDidLoad()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func SetupViewController(){
    }
    func BindData(){
    }
    func BindDataVersion() {
    }
    func RefreshViewController(){
    }
    func loadDataVersion(){
    }
    
    //MARK: RX
    let
    disposeBag = DisposeBag()
    //MARK: loading
    let loadingOverlay = LoadingOverlay()
    var loadingOverlayVisible = false
    //MARK: alerts
    var
    alertController: UIAlertController?,
    viewForLoadingOverlay: UIView?,
    viewForTextAlert: UIView?,
    errorAlertReplyAction: (() -> Void)?
    deinit {
        Logger.logDeInit(self)
    }
    
    //MARK: TableViewRootViewControllerDelegate
    var
    dataFromRootVC:Any?
}

