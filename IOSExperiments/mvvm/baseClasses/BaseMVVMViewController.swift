//
//  BaseMVVMViewController.swift
//  iosExperiments
//
//  Created by 0x384c0 on 1/19/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import UIKit
import RxSwift

class BaseMVVMViewController: UIViewController, BaseMVVMViewControllerProtocol {
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
    
    func setupViewController(){
    }
    func bindData(){
    }
    func BindDataVersion() {
    }
    func refreshViewController(){
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
    errorAlertReplyAction: (() -> Void)?
    deinit {
        Logger.logDeinit(self)
    }
}




//    //MARK: google analytycs
//    override func viewWillAppear(_ animated: Bool) {
//        sendScreenNameToGA()
//    }
//    var
//    trackScreenInGA = true
//    let
//    name = String(self.dynamicType),
//    tracker = GAI.sharedInstance().defaultTracker,
//    builder = GAIDictionaryBuilder.createScreenView()
//    func sendScreenNameToGA(){
//        if trackScreenInGA {
//            tracker.set(kGAIScreenName, value: name)
//            tracker.send(builder.build() as [NSObject : Any])
//        }
//    }

protocol BaseMVVMViewControllerProtocol: class {
    var tabBarSettings:TabBarSettings{get}
    var loadingOverlaySettings:LoadingOverlaySettings{get}
    //MARK: RX
    var disposeBag:DisposeBag {get}
    //MARK: loading
    var loadingOverlay:LoadingOverlay {get}
    var loadingOverlayVisible:Bool {get set}
    //MARK: alerts
    var errorAlertReplyAction:(() -> Void)? {get set}
    var alertController: UIAlertController? {get set}
    var viewForLoadingOverlay: UIView? {get set}
    
    func setupViewController()
    func bindData()
    func refreshViewController()
    //    func BindDataVersion()
}

extension BaseMVVMViewControllerProtocol where Self: UIViewController{
    
    //MARK: lifecycle
    func handleViewDidLoad(){
        Logger.logViewDidLoad(self)
        
        viewForLoadingOverlay = view
        
        
        setEmptyBackButton()
        setupTabBarColors()
        bindData()
        setupViewController()
        refreshViewController()
        //        BindDataVersion()
    }
    
    //MARK: Customizing TabBar
    func setEmptyBackButton(){
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        tabBarController?.navigationItem.backBarButtonItem = backItem
    }
    func setupTabBarColors(){
        if tabBarSettings.isTransparent{
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.navigationBar.barTintColor = UIColor.clear
            navigationController?.view.backgroundColor = UIColor.clear
        } else {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = tabBarSettings.barTintColor
        }
        
        navigationController?.navigationBar.tintColor = tabBarSettings.tintColor
        navigationController?.navigationBar.barStyle = tabBarSettings.barStyle
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //MARK: loading
    func showLoading(_ viewForCustomLoadingOverlay:UIView? = nil){
        loadingOverlay.setup(loadingOverlaySettings)
        navigationItem.rightBarButtonItem?.isEnabled = false
        if !loadingOverlayVisible {
            if let viewForOverlay = viewForCustomLoadingOverlay{
                loadingOverlay.showOverlay(viewForOverlay)
                loadingOverlayVisible = true
            } else if let viewForLoadingOverlay = viewForLoadingOverlay{
                loadingOverlay.showOverlay(viewForLoadingOverlay)
                loadingOverlayVisible = true
            }
        }
        
    }
    func hideLoading(_ animated:Bool = true){
        navigationItem.rightBarButtonItem?.isEnabled = true
        if loadingOverlayVisible {
            loadingOverlay.hideOverlayView(animated)
            loadingOverlayVisible = false
        }
        
    }
    
    //MARK: alerts
    func bindAlerts(from viewModel:BaseViewModelProtocol,popVCAfterDismiss:Bool = false){
        viewModel
            .textAlertBinding
            .subscribeMain(onNext: { [weak self]  text in
                self?.showTextAlert(text, popVCAfterDismiss: popVCAfterDismiss)
            })
            .disposed(by: disposeBag)
        viewModel
            .errorAlertController
            .subscribeMain(onNext: { [weak self]  data in
                let popVCAfterDismissResult = data.popVCAfterDismiss == nil ?
                    popVCAfterDismiss :
                    data.popVCAfterDismiss!
                self?.showAlert(data.vc, popVCAfterDismiss: popVCAfterDismissResult)
            })
            .disposed(by: disposeBag)
    }
    func showAlert(_ alertController:UIAlertController, popVCAfterDismiss:Bool = false){
        self.alertController?.dismiss(animated: false, completion: nil)
        self.alertController = alertController
        
        if let alertController = self.alertController {
            let cancelText:String
            if errorAlertReplyAction != nil{
                alertController.addAction(
                    UIAlertAction(
                        title: "REFRESH".localized,
                        style: UIAlertAction.Style.default,
                        handler: {[weak self]  action in
                            self?.hideLoading(false)
                            self?.errorAlertReplyAction?()
                        }
                    )
                )
                cancelText = "CANCEL".localized
            } else {
                hideLoading()
                cancelText = "CLOSE".localized
            }
            alertController.addAction(
                UIAlertAction(title: cancelText,
                              style: UIAlertAction.Style.default,
                              handler: {[weak self]  action in
                                self?.hideLoading()
                                if popVCAfterDismiss{
                                    _ = self?.navigationController?.popViewController(animated: true)
                                }
                    }
                )
            )
            present(alertController, animated: true, completion: nil)
        }
    }
    func showTextAlert(_ text:String?,                  popVCAfterDismiss:Bool = false, callback: (() -> ())? = nil) {
        if let text = text{
            
            let alertController = UIAlertController()
            alertController.message = text
            alertController.addAction(
                UIAlertAction(
                    title: "CLOSE".localized,
                    style: UIAlertAction.Style.default,
                    handler: {[weak self] _ in
                        if popVCAfterDismiss {
                            _ = self?.navigationController?.popViewController(animated: true)
                        }
                        callback?()
                    }
                )
            )
            present(alertController, animated: true, completion: nil)
        }
        hideLoading()
    }
    //others
    func printUndefinedSegue(_ segue:UIStoryboardSegue){
        Logger.log(
            "WARNING!!! UNHANDLED SEGUE!!!\nidentifier: \(String(describing: segue.identifier))\ndestination: \(segue.destination)",
            .warn
        )
    }
    func showReplyActionInAlerts(){
        errorAlertReplyAction = {[weak self] in
            self?.refreshViewController()
        }
    }
}

struct TabBarSettings{
    let
    barStyle:UIBarStyle,
    tintColor:UIColor,
    barTintColor:UIColor,
    isTransparent:Bool
}

//import RxSwift
//
//class SampleViewController: BaseMVVMViewController {
//    //MARK: UI
//
//    //MARK: UI Actions
//
//    //MARK: LifeCycle
//    override func SetupViewController(){
//        //showReplyActionInAlerts()
//    }
//    override func RefreshViewController() {
//        showLoading()
//        viewModel.loadData()
//    }
//
//
//    //MARK: Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier ?? "" {
//        case SampleViewController.segueID:
//            let
//            vc = segue.destination as! SampleViewController,
//            data = sender as? DATA_TYPE
//            vc.setup(data)
//        default:
//            printUndefinedSegue(segue)
//        }
//    }
//
//    //MARK: Binding
//    private let viewModel = SampleViewModel()
//    override func BindData() {
//    bindAlerts(from: viewModel)
//        viewModel
//            .dataBinding
//            .subscribeMain(onNext: { [weak self] data in
//                self?.load(data: data)
//                self?.hideLoading()
//            })
//            .disposed(by: disposeBag)
//    }
//
//    //MARK: other
//    private func load(data: DATA_TYPE){
//
//    }
//}

