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
    /*先简单的介绍下CAShapeLayer
     CAShapeLayer继承自CALayer，可使用CALayer的所有属性
     CAShapeLayer需要和贝塞尔曲线配合使用才有意义。
     Shape：形状,贝塞尔曲线可以为其提供形状，而单独使用CAShapeLayer是没有任何意义的。
     使用CAShapeLayer与贝塞尔曲线可以实现不在view的DrawRect方法中画出一些想要的图形
     关于CAShapeLayer和DrawRect的比较
     
     DrawRect：DrawRect属于CoreGraphic框架，占用CPU，消耗性能大
     CAShapeLayer：CAShapeLayer属于CoreAnimation框架，通过GPU来渲染图形，节省性能。动画渲染直接提交给手机GPU，不消耗内存
     
     贝塞尔曲线与CAShapeLayer的关系
     CAShapeLayer中shape代表形状的意思，所以需要形状才能生效
     贝塞尔曲线可以创建基于矢量的路径
     贝塞尔曲线给CAShapeLayer提供路径，CAShapeLayer在提供的路径中进行渲染。路径会闭环，所以绘制出了Shape
     用于CAShapeLayer的贝塞尔曲线作为Path，其path是一个首尾相接的闭环的曲线，即使该贝塞尔曲线不是一个闭环的曲线
     */
    
    public var progressCorlor: UIColor = UIColor.green;
    private static var progressView = UIView()
    private var progressLayer = CAShapeLayer(layer: YLWKWebView.progressView.layer)
    private var oldValue: Float = 0
    
    deinit {
        self.removeObserver(self, forKeyPath: "estimatedProgress");
    }
    
    private func initProgressView() {
        YLWKWebView.progressView.frame = CGRect(x: 0, y: 64, width: self.bounds.width, height: 4);
        YLWKWebView.progressView.backgroundColor = UIColor.clear;
        self.addSubview(YLWKWebView.progressView);
        progressLayer.borderWidth = 1
        progressLayer.lineWidth = 4
        progressLayer.fillColor = UIColor.clear.cgColor
        tintColorDidChange()
        YLWKWebView.progressView.layer.addSublayer(self.progressLayer)
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
                update(progress: CGFloat(newValue.floatValue))
                if newValue == 1 {
                    oldValue  = 0;
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.update(progress: CGFloat(0))
                    });
                }
            }else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context);
            }
        }
    }
    
    private func update(progress: CGFloat) {
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



























