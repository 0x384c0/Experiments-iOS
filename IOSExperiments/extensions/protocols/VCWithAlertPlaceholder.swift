//
//  VCWithAlertPlaceholder.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 25.12.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//



protocol VCWithAlertPlaceholder:class {
    var alertDialogPlaceholder : AlertDialogPlaceholder? { get set }
    func vcWithAlertPlaceholderGetView() -> UIView?
    func vcWithAlertPlaceholderGetStyle() -> UIScrollViewIndicatorStyle?
}
extension VCWithAlertPlaceholder where Self:BaseViewController{
    func bindAlerts(from viewModel:BaseViewModelProtocol,popVCAfterDismiss:Bool = false){
        viewModel
            .textAlertBinding
            .subscribeMain(onNext: { [weak self]  text in
                self?.showTextAlert(text,popVCAfterDismiss: popVCAfterDismiss)
            })
            .addDisposableTo(disposeBag)
        viewModel
            .errorAlertController
            .subscribeMain(onNext: { [weak self]  alertController in
                self?.showPlaceholderDialog(alertController)
            })
            .addDisposableTo(disposeBag)
    }
    
    func showPlaceholderDialog(_ alertBindingData:VMAlertBindingData){
        ((self as Any) as? VCWithRefreshControlInTable)?.hideLoading()
        ((self as Any) as? BaseViewController)?.hideLoading()
        alertDialogPlaceholder = AlertDialogPlaceholder(
            title: alertBindingData.vc.message,
            message: nil,
            buttonText: "TRY_AGAIN".localized,
            handler: {[weak self]  button in
                self?.RefreshViewController()
                self?.alertDialogPlaceholder?.hide()
            }
        )
        if let style = vcWithAlertPlaceholderGetStyle(){
            alertDialogPlaceholder?.style = style
        }
        alertDialogPlaceholder?.show(for: vcWithAlertPlaceholderGetView() ?? view)
    }
    func vcWithAlertPlaceholderGetView() -> UIView?{return nil}
    func vcWithAlertPlaceholderGetStyle() -> UIScrollViewIndicatorStyle?{return nil}
    
}

