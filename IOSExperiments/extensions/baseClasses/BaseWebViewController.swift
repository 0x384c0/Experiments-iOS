//
//  BaseWebViewController.swift
//  iosExperiments
//
//  Created by Andrew Ashurow on 3/28/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import RxSwift

class BaseWebViewController : BaseViewController {
    
    deinit {
        Logger.logDeInit(self)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    //MARK: UI
    func getWebView() -> UIWebView {
        preconditionFailure("This method must be overridden")
    }
    
    fileprivate var
    refreshControl = UIRefreshControl()
    
    //MARK: UI Actions
    func handleRefresh(_ refreshControl: UIRefreshControl){
        getWebView().reload()
    }
    
    //MARK: LifeCycle
    override func SetupViewController(){
        errorAlertReplyAction = nil
        getWebView().delegate = self
        refreshControl.attributedTitle = NSAttributedString(string: "REFRESHING".localized)
        refreshControl.addTarget(self, action: #selector(BaseWebViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        getWebView().scrollView.addSubview(refreshControl)
        showLoading()
    }
    override func RefreshViewController() {
        getViewModel().loadUrl()
    }
    
    //MARK: Binding
    func getViewModel() -> WebViewModelProtocol {
        preconditionFailure("This method must be overridden")
    }
    override func BindData() {
        bindAlerts(from: getViewModel() as BaseViewModelProtocol,popVCAfterDismiss:true)
        getViewModel()
            .requestBinding
            .subscribeMain{[weak self] request in
                self?.getWebView().loadRequest(request)
                self?.refreshControl.beginRefreshing()
            }
            .addDisposableTo(disposeBag)
        
        getViewModel()
            .urlResultBinding
            .subscribeMain{[weak self] result in
                self?.webViewResult(result: result)
            }
            .addDisposableTo(disposeBag)
    }
    
    func webViewResult(result:WebViewResult){
        if result == .SHOW_LOADING {
            showLoading()
            return
        }
        if result != WebViewResult.NONE {
            if let navContr = navigationController{
                navContr.popViewController(animated: true)
            } else {
                dismiss(animated: true, completion: nil)
            }
        }
    }
}
enum WebViewResult{
    case
    SHOW_LOADING,
    SUCCESS,
    FAIL,
    NONE
}
extension BaseWebViewController : UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url?.absoluteString
        return getViewModel().shouldStartLoadWithRequest(url: url)
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("webViewDidStartLoad  \(webView.request?.url)")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        refreshControl.beginRefreshingProgrammatically()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        hideLoading()
        refreshControl.endRefreshing()
        navigationItem.title = webView.stringByEvaluatingJavaScript(from: "document.title")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
