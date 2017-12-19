//
//  ViewController.swift
//  WKWebViewTest
//
//  Created by 王留根 on 2017/4/29.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit
import WebKit

let progressKey = "progressKey"

class ViewController: UIViewController {

    var webView: YLWKWebView!
    let strUrl = "http://192.168.20.14:8080/protocal"
    //"https://www.baidu.com/"
    //
//   // var webView: UIWebView!
//    var progressView: UIProgressView!
    
    deinit {
         webView.removeObserver(self, forKeyPath: progressKey)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //创建webview
        //创建一个webview的配置项
        let configuretion = WKWebViewConfiguration();
        // Webview的偏好设置
        configuretion.preferences = WKPreferences()
        configuretion.preferences.minimumFontSize = 10
        configuretion.preferences.javaScriptEnabled = true
        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = false
        configuretion.preferences.javaScriptEnabled = true
        //通过js与webview内容交互配置
        configuretion.userContentController = WKUserContentController();
        //添加一个名称就可以在js通过这个名称发消息：
        
        webView = YLWKWebView(frame: CGRect(x:0, y: 0, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height),configuration:configuretion)
        webView.addObserver(self, forKeyPath: progressKey, options: .new, context: nil)
        webView.backgroundColor = UIColor.clear
        webView.scrollView.bounces = true
        webView.scrollView.alwaysBounceVertical = true
        webView.allowsBackForwardNavigationGestures = true
        webView.isMultipleTouchEnabled = true
        webView.progressCorlor = UIColor.red;
       // if #available(iOS 9.0, *) {webView.allowsLinkPreview = true}
        webView.navigationDelegate = self;
        webView.uiDelegate = self;
        view.addSubview(webView)
        let image = UIImage(named: "back")
        let leftItem: UIBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(canBack))
        self.navigationItem.leftBarButtonItem = {leftItem}();
       // [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gobackItem.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backViewcontroller)];
        
       
//        webView.configuration.userContentController.addUserScript(WKUserScript(source: "window.webkit.messageHandlers.openItemDetail.postMessage({body: ''});", injectionTime: .atDocumentEnd, forMainFrameOnly: false))
        configuretion.userContentController.add(self, name: "openItemDetail");
        
        
//        webView.evaluateJavaScript(" ") { (repond, error) in
//            
//        }
       
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        _ = webView.load(URLRequest(url: URL(string: strUrl)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print(",newProgress = ")
    }
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print(",newProgress = ")
//        if keyPath==progressKey {
//            let newProgress  = Float(self.webView.estimatedProgress)
//            print(",newProgress = \(newProgress)")
//
//        }
//    }

    func canBack() {
        if webView.canGoBack {
            webView.goBack()
        }
        
    }

}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let urlString = navigationAction.request.url?.absoluteString
        print("\(String(describing: urlString))")
        decisionHandler(.allow)
        
        
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title =  webView.title
        print("load didFinish")
    }
//    
//    // 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接
//    // 单独处理。但是，对于Safari是允许跨域的，不用这么处理。
//    // 这个是决定是否Request
//    - (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
//    
//    // 决定是否接收响应
//    // 这个是决定是否接收response
//    // 要获取response，通过WKNavigationResponse对象获取
//    - (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;
//    
//    // 当main frame的导航开始请求时，会调用此方法
//    - (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
//    
//    // 当main frame接收到服务重定向时，会回调此方法
//    - (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
//    
//    // 当main frame开始加载数据失败时，会回调
//    - (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
//    
//    // 当main frame的web内容开始到达时，会回调
//    - (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation;
//    
//    // 当main frame导航完成时，会回调
//    - (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
//    
//    // 当main frame最后下载数据失败时，会回调
//    - (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
//    
//    // 这与用于授权验证的API，与AFN、UIWebView的授权验证API是一样的
//    - (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler;
//    
//    // 当web content处理完成时，会回调
//    - (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0);


}

extension ViewController: WKUIDelegate {
//    // 创建新的webview
//    // 可以指定配置对象、导航动作对象、window特性
//    - (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures;
//    
//    // webview关闭时回调
//    - (void)webViewDidClose:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0);
//    
//    // 调用JS的alert()方法
//    - (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler;
//    
//    // 调用JS的confirm()方法
//    - (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler;
//    
//    // 调用JS的prompt()方法
//    - (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler;

    
}

extension ViewController: WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "openItemDetail" {
            print("message")
        }
    }
    

}
































