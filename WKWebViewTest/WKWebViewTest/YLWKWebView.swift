//
//  YLWKWebView.swift
//  WKWebViewTest
//
//  Created by 王留根 on 2017/8/11.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit
import WebKit

class YLWKWebView: WKWebView {
    
    public var progressCorlor: UIColor = UIColor.green;
    private var progressLayer: CALayer = CALayer()
    private var oldValue: Float = 0
    
    deinit {
        self.removeObserver(self, forKeyPath: "estimatedProgress");
    }
    
    private func initProgressView() {
        let progressView = UIView(frame: CGRect(x: 0, y: 64, width: self.bounds.width, height: 3));
        progressView.backgroundColor = UIColor.clear;
        self.addSubview(progressView);
        progressLayer.frame = CGRect(x: 0, y: 0, width: 0, height: 3);
        progressLayer.backgroundColor = progressCorlor.cgColor;
        progressView.layer.addSublayer(progressLayer);
        //print("初始化完成")
    }
    
    override func load(_ request: URLRequest) -> WKNavigation? {
        initProgressView();
        self.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);
        return super.load(request);
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath: String = keyPath ,let change: [NSKeyValueChangeKey : Any] = change {
            if keyPath == "estimatedProgress" {
                self.progressLayer.opacity = 1;
                let newValue: NSNumber = change[NSKeyValueChangeKey.newKey] as! NSNumber
                if newValue.floatValue < oldValue {
                    return
                }
                oldValue = newValue.floatValue
                //print("值变化: \(String(describing: change[NSKeyValueChangeKey.newKey]))   旧值：  \(oldValue)");
                self.progressLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width * CGFloat(newValue.floatValue), height: 3);
                if newValue == 1 {
                    oldValue  = 0;
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.progressLayer.opacity = 0;
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { 
                        self.progressLayer.frame = CGRect(x: 0, y: 0, width: 0, height: 3);
                    });
                }
            }else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context);
            }
        }
    }


}



























