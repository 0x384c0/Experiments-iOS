//
//  BaseViewModel.swift
//  iosExperiments
//
//  Created by 0x384c0 on 1/19/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import RxSwift

class BaseViewModel: NSObject, BaseViewModelProtocol{
    
    deinit {
        Logger.logDeinit(self)
    }
    
    //MARK: RX
    let
    disposeBag = DisposeBag(),
    scheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "serialScheduler"),
    notifications = Notifications()
    
    //MARK: BaseViewModelProtocol
    var
    errorAlertController    = PublishSubject<VMAlertBindingData>(),
    textAlertBinding        = PublishSubject<String?>(),
    isLoading = false
    
    //MARK: newtork error observer
    func getOnErrorObserver(_ title:String? = nil, popVCAfterDismiss:Bool? = nil, handler:(() -> Void)? = nil) -> ((Error) -> Void) {
        return {[weak self] e in
            self?.isLoading = false
            
//            //401 Unauthoriser error
//            if e.statusCode == Constants.UNAUTHORISED_STATUC_CODE{
//                SessionManager.shared.logoutDueUnauthorisedError()
//                return
//            }
            
            //server error with message
            if let message = BaseResponse.parse(e.responseBody)?.message{
                self?.showAlertErrorDialog("ERROR".localized, message: message, popVCAfterDismiss:popVCAfterDismiss)
                return
            }
            
            //network or server error
            handler?()
            if let reason = e.localizedFailureReason {
                self?.showAlertErrorDialog("ERROR".localized, message: "ERROR_CONNECTION_TITLE".localized + ": " + reason, popVCAfterDismiss:popVCAfterDismiss)
            } else {
                self?.showAlertErrorDialog(popVCAfterDismiss:popVCAfterDismiss)
            }
        }
    }
}
typealias VMAlertBindingData = (vc:UIAlertController,popVCAfterDismiss:Bool?)
protocol BaseViewModelProtocol: class {
    var errorAlertController: PublishSubject<VMAlertBindingData>{get set}
    var textAlertBinding:PublishSubject<String?>{get set}
    var isLoading:Bool{get set}
}
extension BaseViewModelProtocol {
    func showAlertErrorDialog(
        _ title:String? = "ERROR_CONNECTION_TITLE".localized,
        message:String? = "ERROR_CONNECTION_MESSAGE".localized,
        popVCAfterDismiss:Bool? = nil
        ){
        self.isLoading = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        errorAlertController.value = (vc:UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
            ), popVCAfterDismiss:popVCAfterDismiss)
    }
    func showTextAlert(_ text:String?){
        textAlertBinding.value = text
    }
}

//import RxSwift
//
//class SampleViewModel: BaseViewModel {
//
//    //MARK: UI Binding
//    var
//    dataBinding = Variable<DATA_TYPE?>(nil)
//
//    //MARK: Data fetching
//    func loadData(){
//        apiService
//            .getData()
//            .subscribeOn(scheduler)
//            .subscribe(
//                onNext: {[weak self] data in
//                    self?.dataBinding.value = data
//                },
//                onError: getOnErrorObserver()
//            )
//            .disposed(by: disposeBag)
//    }
//}
