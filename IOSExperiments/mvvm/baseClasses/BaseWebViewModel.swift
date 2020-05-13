//
//  BaseWebViewModel
//  iosExperiments
//
//  Created by Andrew Ashurow on 3/16/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//


import RxSwift

protocol WebViewModelProtocol:BaseViewModelProtocol {
    //MARK: UI Binding
    var requestBinding          : PublishSubject<URLRequest>  { get }
    var urlResultBinding        : PublishSubject<WebViewResult>  { get }
    var errorAlertController    : PublishSubject<VMAlertBindingData> { get set }
    var textAlertBinding        : PublishSubject<String?> { get set }
    //MARK: other
    var request                 : URLRequest?{ get }
    func shouldStartLoadWithRequest(url: String?) -> Bool
}

extension WebViewModelProtocol{
    //MARK: Data fetching
    func loadUrl(){
        if let request = request {
            self.requestBinding.value = request
        } else {
            urlResultBinding.value = WebViewResult.FAIL
        }
    }
}
