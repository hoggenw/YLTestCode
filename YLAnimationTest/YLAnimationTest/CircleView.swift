//
//  CircleView.swift
//  YLAnimationTest
//
//  Created by 王留根 on 2017/10/9.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit
import QuartzCore
import Foundation

class CircleView: UIView {

    
    var circleLayer1 :CAShapeLayer!
    var circleLayer2 :CAShapeLayer!
    
    let baseAnimation1 = CABasicAnimation(keyPath: "transform.rotation.z");
    let baseAnimation2 = CABasicAnimation(keyPath: "transform.rotation.z");
    
    var circle2View: UIView = UIView()
    
    public var progressTimer: Timer?
    
    deinit {

    }
    override init(frame: CGRect) {
        super.init(frame: frame);
        circle2View.frame = self.bounds;
        circle2View.backgroundColor = UIColor.clear;
        self.addSubview(circle2View);
        self.backgroundColor = UIColor.clear;
        self.circleLayer1 = CAShapeLayer();
        circleLayer1.frame = self.bounds;
        circleLayer1.borderWidth = 1
        circleLayer1.lineWidth = 3
        circleLayer1.fillColor = UIColor.clear.cgColor
        circleLayer1.lineCap = kCALineCapRound;
        
        self.circleLayer2 = CAShapeLayer();
        circleLayer2.frame = self.bounds;
        circleLayer2.borderWidth = 1
        circleLayer2.lineWidth = 3
        circleLayer2.fillColor = UIColor.clear.cgColor
        circleLayer2.lineCap = kCALineCapRound;
        
        tintColorDidChange()
        self.layer.addSublayer(self.circleLayer1)
        circle2View.layer.addSublayer(self.circleLayer2)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Color
    override open func tintColorDidChange() {
        if (self.superclass?.instancesRespond(to: #selector(tintColorDidChange)))! {
            super.tintColorDidChange()
        }
        
        circleLayer1.strokeColor = UIColor.green.cgColor
        circleLayer1.borderColor = UIColor.clear.cgColor
        
        circleLayer2.strokeColor = UIColor.red.cgColor
        circleLayer2.borderColor = UIColor.clear.cgColor

    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        circleLayer1.cornerRadius = frame.size.width / 2.0
        circleLayer1.path = circleLayer1Path().cgPath
        
        circleLayer2.cornerRadius = frame.size.width / 2.0
        circleLayer2.path = circleLayer2Path().cgPath
    }
    
    func circleLayer1Path() -> UIBezierPath {
        
        let startAngle = Double.pi;
        let endAngle = startAngle + Double.pi * 0.8;

        let width = self.frame.size.width;
        let borderWidth = self.circleLayer1.borderWidth;
        
        let path = UIBezierPath(arcCenter: CGPoint(x: width/2, y: width/2), radius: width/2 - borderWidth, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise:  true);
        
        path.lineWidth     = borderWidth
        path.lineJoinStyle = .round //终点处理
        return path;
    }
    
    func circleLayer2Path() -> UIBezierPath {
        
        let startAngle: Double = 0;
        let endAngle = startAngle + Double.pi * 0.8;
        
        let width = self.frame.size.width;
        let borderWidth = self.circleLayer1.borderWidth;
        
        let path = UIBezierPath(arcCenter: CGPoint(x: width/2, y: width/2), radius: width/2 - borderWidth, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise:  true);
        
        path.lineWidth     = borderWidth
        path.lineJoinStyle = .round //终点处理
        return path;
    }
    
    public func beginAnimation() {
        
        installAnimation(baseAnimation: baseAnimation1);
        baseAnimation1.beginTime = CACurrentMediaTime() + 0.1;
        installAnimation(baseAnimation: baseAnimation2);
        circleLayer1.add(baseAnimation1, forKey: "baseanimation1");
        circleLayer2.add(baseAnimation2, forKey: "baseanimation2")
    }
    
    private func installAnimation(baseAnimation: CABasicAnimation) {
        baseAnimation.fromValue = Double.pi * 2;
        baseAnimation.toValue = 0;
        baseAnimation.duration = 3;
        baseAnimation.repeatCount = HUGE;
        baseAnimation.timingFunction =  CAMediaTimingFunction(name:  kCAMediaTimingFunctionEaseOut);//[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    }
}


























