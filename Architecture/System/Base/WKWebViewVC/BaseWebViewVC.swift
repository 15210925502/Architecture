//
//  BaseWebViewVC.swift
//  Architecture
//
//  Created by HLD on 2020/5/20.
//  Copyright © 2020 com.cn.HLD. All rights reserved.
//

import UIKit
import WebKit

class BaseWebViewVC: BaseVC,WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate {
    
    var baseUrl : String = ConfigurationFile.h5baseURLString
    var timeout : TimeInterval = 60
    
    override init(query: Dictionary<String, Any>?) {
        super.init(query: query)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.webView)
        self.view.addSubview(self.progressView)
        //监听进度
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.webView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self.view)
        }
        self.progressView.mas_makeConstraints { (make) in
            make?.top.left()?.equalTo()(0)
            make?.width.equalTo()(self.webView.mas_width)
            make?.height.equalTo()(BaseTools.adapted(value: 0.8))
        }
    }
    
    lazy var webView : WKWebView = {
        let config : WKWebViewConfiguration = self.getWkWebViewConfiguration()
        var webView = WKWebView.init(frame: CGRect.zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        // 允许左右划手势导航，默认NO
        webView.allowsBackForwardNavigationGestures = true
        return webView;
    }()
    
    lazy var progressView : UIProgressView = {
        var progressView = UIProgressView()
        progressView.theme_tintColor = "E0514C"
        progressView.trackTintColor = UIColor.sd_color(withID: "FFFFFF")
        return progressView;
    }()
    
    func getWkWebViewConfiguration() -> WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 10
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        return config;
    }
    
    // 计算wkWebView进度条
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            self.progressView.alpha = 1.0
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
            if self.webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0.0
                }, completion: { (finish) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
        if !self.webView.isLoading {
            UIView.animate(withDuration: 0.5) {
                self.progressView.alpha = 0.0
            }
        }
    }
    
    func load(_ request: URLRequest){
        //        case useProtocolCachePolicy//默认方式
        //        case reloadIgnoringLocalCacheData//不使用缓存
        //        case reloadIgnoringLocalAndRemoteCacheData//决不使用任何缓存
        //        case returnCacheDataElseLoad//使用缓存（不管它是否过期），如果缓存中没有，那从网络加载吧
        //        case returnCacheDataDontLoad//离线模式：使用缓存（不管它是否过期），但是不从网络加载
        //        case reloadRevalidatingCacheData//验证本地数据与远程数据是否相同，如果不同则下载远程数据，否则使用本地数据
        //        let request = URLRequest.init(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 15.0)
        
        var tempRequest = request
        tempRequest.cachePolicy = .reloadIgnoringLocalCacheData
        tempRequest.timeoutInterval = 30.0
        
        if NetworkHelper.sharedManager()?.isNetworkAvailable ?? false {
            self.webView.load(tempRequest)
        }else{
            weak var weakSelf = self
            self.view.setErrorTpye(YYLLoadErrorTypeNoNetwork) {
                weakSelf?.webView.load(tempRequest)
            }
        }
    }
    
//    加载成功
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title(title: webView.title ?? "")
        if self.webView.canGoBack {
            self.showNavRightButton()
        }else{
            self.hiddenNavRightButton()
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    //需要响应身份验证时调用 同样在block中需要传入用户身份凭证
    //WKWebView加载不受信任的https,即证书过期的https
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust && challenge.previousFailureCount == 0 {
            let card : URLCredential = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential,card);
        }else{
            completionHandler(.cancelAuthenticationChallenge, nil);
        }
    }
    
//    加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {

    }
    
//    WkWebview不支持 window.open的解决方法
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame?.isMainFrame == nil {
            self.load(navigationAction.request)
        }
        return nil
    }
    
    override func responseSysLeftButtonAction() {
        self.webView.stopLoading()
        if self.webView.canGoBack {
            self.webView.goBack()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func responseLeftButtonAction() {
        self.webView.stopLoading()
        if self.webView.canGoBack {
            self.webView.goBack()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    ///    根据标题名字返回指定H5页面
    func backAppointH5View(_ titleName : String){
        //历史记录的列表
        print(self.webView.backForwardList.backList)
        var tempItem : WKBackForwardListItem?
        //循环遍历里面历史记录，根据标题返回到指定的历史页面
        for index in 0..<self.webView.backForwardList.backList.count{
            let item : WKBackForwardListItem = self.webView.backForwardList.backList.safeIndex(index)!
            print(item.url)
            print(item.title ?? "")
            print(item.initialURL)
            if item.title == titleName {
                tempItem = item
            }
        }
        if tempItem != nil{
            self.webView.go(to: tempItem!)
        }
    }
    
    ///    根据下标返回指定H5页面
    func backAppointH5View(_ index : NSInteger){
        let item = self.webView.backForwardList.backList.safeIndex(index)
        if item != nil{
            self.webView.go(to: item!)
        }
    }
    
    //清除所有缓存
    func removeCookies(_ finishHandler: (() -> Void)? = nil) {
        let dateStore : WKWebsiteDataStore = WKWebsiteDataStore.default()
        dateStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            var count = 0
            for record in records{
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) {
                    print("Cookies 中的 \(record.displayName) 删除成功！")
                    count = count + 1
                    if count == records.count {
                        if (finishHandler != nil) {
                            finishHandler!()
                        }
                    }
                }
            }
        }
    }
    //自定义清除缓存
    func customDeleteWebCache(_ finishHandler: (() -> Void)? = nil){
        /*
         Cookies
         WKWebsiteDataTypeCookies,
         
         本地存储。
         WKWebsiteDataTypeLocalStorage,
         
         在磁盘缓存上。
         WKWebsiteDataTypeDiskCache,
         
         内存缓存。
         WKWebsiteDataTypeMemoryCache,
         
         html离线Web应用程序缓存。
         WKWebsiteDataTypeOfflineWebApplicationCache,
         
         会话存储
         WKWebsiteDataTypeSessionStorage,
         
         IndexedDB数据库。
         WKWebsiteDataTypeIndexedDBDatabases,
         
         查询数据库。
         WKWebsiteDataTypeWebSQLDatabases
         */
        let types = [WKWebsiteDataTypeCookies,
                     WKWebsiteDataTypeLocalStorage,
                     WKWebsiteDataTypeDiskCache,
                     WKWebsiteDataTypeMemoryCache,
                     WKWebsiteDataTypeOfflineWebApplicationCache,
                     WKWebsiteDataTypeSessionStorage,
                     WKWebsiteDataTypeIndexedDBDatabases,
                     WKWebsiteDataTypeWebSQLDatabases];
        let websiteDataTypes : NSSet = NSSet.init(array: types)
        let date : NSDate = NSDate.init(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date) {
            if (finishHandler != nil) {
                finishHandler!()
            }
        }
    }
    
    deinit {
        print("对象已被释放")
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.uiDelegate = nil
        self.webView.navigationDelegate = nil
    }
}
