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
    private static var progressView = UIView()
    private var progressLayer = CAShapeLayer(layer: YLWKWebView.progressView.layer)
    private var oldValue: Float = 0
    
    deinit {
        self.removeObserver(self, forKeyPath: "estimatedProgress");
    }
    
    private func initProgressView() {
        YLWKWebView.progressView.frame = CGRect(x: 0, y: 64, width: self.bounds.width, height: 3);
        YLWKWebView.progressView.backgroundColor = UIColor.clear;
        self.addSubview(YLWKWebView.progressView);
        progressLayer.borderWidth = 1
        progressLayer.lineWidth = 3
        progressLayer.fillColor = UIColor.clear.cgColor
        tintColorDidChange()
        YLWKWebView.progressView.layer.addSublayer(self.progressLayer)
        //print("初始化完成")
    }
    //MARK: - Color
    override open func tintColorDidChange() {
        if (self.superclass?.instancesRespond(to: #selector(tintColorDidChange)))! {
            super.tintColorDidChange()
        }
        
        progressLayer.strokeColor = progressCorlor.cgColor
        progressLayer.borderColor = progressCorlor.cgColor
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
                //self.progressLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width * CGFloat(newValue.floatValue), height: 3);
                update(progress: CGFloat(newValue.floatValue))
                if newValue == 1 {
                    oldValue  = 0;
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        self.progressLayer.opacity = 0;
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.update(progress: CGFloat(0))
                        //self.progressLayer.frame = CGRect(x: 0, y: 0, width: 0, height: 3);
                    });
                }
            }else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context);
            }
        }
    }
    
    open func update(progress: CGFloat) {
        CATransaction.begin()
        //显式事务默认开启动画效果,kCFBooleanTrue关闭
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        progressLayer.strokeEnd = progress
        progressLayer.strokeStart = 0
        CATransaction.commit()
        
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        progressLayer.cornerRadius = frame.size.width / 2.0
        
        progressLayer.path = shapeLayerPath().cgPath
    }
    
    func shapeLayerPath() -> UIBezierPath {
        
        let width = self.frame.size.width;
        let borderWidth = self.progressLayer.borderWidth;
        
        let path = UIBezierPath()
        
        path.lineWidth     = borderWidth
        path.lineJoinStyle = .round //终点处理
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        return path;
    }



}



























