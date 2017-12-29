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
    var arrows1 : CAShapeLayer!
    var arrow1StartPath: UIBezierPath!
    var arrow1EndPath: UIBezierPath!
    
    var circleLayer2 :CAShapeLayer!
    var arrows2Layer : CAShapeLayer!
    var arrow2StartPath: UIBezierPath!
    var arrow2EndPath: UIBezierPath!
   
    let baseAnimation1 = CABasicAnimation(keyPath: "transform.rotation.z");
    let baseAnimation2 = CABasicAnimation(keyPath: "transform.rotation.z");
    
    let keyAnimation2 = CAKeyframeAnimation(keyPath: "path");
    let keyAnimation1 = CAKeyframeAnimation(keyPath: "path");
    
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
        
        self.arrows1 = CAShapeLayer();
        arrows1.frame = self.bounds;
        arrows1.borderWidth = 1
        arrows1.lineWidth = 3
        arrows1.fillColor = UIColor.clear.cgColor
        arrows1.lineCap = kCALineCapRound;
        
        self.circleLayer2 = CAShapeLayer();
        circleLayer2.frame = self.bounds;
        circleLayer2.borderWidth = 1
        circleLayer2.lineWidth = 3
        circleLayer2.fillColor = UIColor.clear.cgColor
        circleLayer2.lineCap = kCALineCapRound;
        
        self.arrows2Layer = CAShapeLayer();
        arrows2Layer.frame = self.bounds;
        arrows2Layer.borderWidth = 1
        arrows2Layer.lineWidth = 3
        arrows2Layer.fillColor = UIColor.clear.cgColor
        arrows2Layer.lineCap = kCALineCapRound;
        
        tintColorDidChange()
        self.layer.addSublayer(self.circleLayer1)
        self.circleLayer1.addSublayer( arrows1);
        
        circle2View.layer.addSublayer(self.circleLayer2)
        self.circleLayer2.addSublayer(arrows2Layer);
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
        
        arrows1.strokeColor = UIColor.green.cgColor
        arrows1.borderColor = UIColor.clear.cgColor
        
        circleLayer2.strokeColor = UIColor.red.cgColor
        circleLayer2.borderColor = UIColor.clear.cgColor
        
        arrows2Layer.strokeColor = UIColor.red.cgColor
        arrows2Layer.borderColor = UIColor.clear.cgColor

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
        
        let pointX: CGFloat = 0 ;
        let pointY = 0 + self.frame.size.height/2;
        let originPoint = CGPoint(x: pointX + 0.5, y: pointY + 0.5 );
        let leftPonit = CGPoint(x: pointX - 8, y: pointY - 10);
        let rightPoint = CGPoint(x: pointX + 12, y: pointY - 8)
        
        arrow1StartPath = UIBezierPath();
        arrow1StartPath.move(to: leftPonit);
        arrow1StartPath.addLine(to: originPoint);
        arrow1StartPath.addLine(to: rightPoint);
        arrow1StartPath.lineJoinStyle = .round //终点处理
        
        
        let leftUpPonit = CGPoint(x: pointX - 2, y: pointY - 12 );
        let rightUPPoint = CGPoint(x: pointX + 6, y: pointY - 10)
        
        arrow1EndPath = UIBezierPath();
        arrow1EndPath.move(to: leftUpPonit);
        arrow1EndPath.addLine(to: originPoint);
        arrow1EndPath.addLine(to: rightUPPoint);
        arrow1EndPath.lineJoinStyle = .round //终点处理
        arrows1.path = arrow1StartPath.cgPath;
        
        return path;
    }
    
    func circleLayer2Path() -> UIBezierPath {
        
        let startAngle: Double = 0;
        let endAngle = startAngle + Double.pi * 0.85;
        
        let width = self.frame.size.width;
        let borderWidth = self.circleLayer1.borderWidth;
        
        let path = UIBezierPath(arcCenter: CGPoint(x: width/2, y: width/2), radius: width/2 - borderWidth, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise:  true);
        
        path.lineWidth     = borderWidth
        path.lineJoinStyle = .round //终点处理
        let pointX = 0 + self.frame.size.width;
        let pointY = 0 + self.frame.size.height/2;
        let originPoint = CGPoint(x: pointX - 0.5, y: pointY - 0.5 );
        let leftPonit = CGPoint(x: pointX - 12, y: pointY + 8);
        let rightPoint = CGPoint(x: pointX + 8, y: pointY + 10)
        
        arrow2StartPath = UIBezierPath();
        arrow2StartPath.move(to: leftPonit);
        arrow2StartPath.addLine(to: originPoint);
        arrow2StartPath.addLine(to: rightPoint);
        arrow2StartPath.lineJoinStyle = .round //终点处理
        
        let leftUpPonit = CGPoint(x: pointX - 14, y: pointY - 14 );
        let rightUPPoint = CGPoint(x: pointX + 6.5, y: pointY - 16)
        
        arrow2EndPath = UIBezierPath();
        arrow2EndPath.move(to: leftUpPonit);
        arrow2EndPath.addLine(to: originPoint);
        arrow2EndPath.addLine(to: rightUPPoint);
        arrow2EndPath.lineJoinStyle = .round //终点处理

        arrows2Layer.path = arrow2StartPath.cgPath;
        
        return path;
    }
    
    public func beginAnimation() {
        
        installAnimation(baseAnimation: baseAnimation1);
        baseAnimation1.beginTime = CACurrentMediaTime() + 0.1;
        installAnimation(baseAnimation: baseAnimation2);
        let values2 = [arrow2StartPath.cgPath,arrow2EndPath.cgPath,arrow2StartPath.cgPath,arrow2EndPath.cgPath,arrow2StartPath.cgPath];
        installKeyframeAnimation(keyAnimation: keyAnimation2, values: values2);
        
        let values1 = [arrow1StartPath.cgPath,arrow1EndPath.cgPath,arrow1StartPath.cgPath,arrow1EndPath.cgPath,arrow1StartPath.cgPath];
        installKeyframeAnimation(keyAnimation: keyAnimation1, values: values1);
        
        circleLayer1.add(baseAnimation1, forKey: "baseanimation1");
        circleLayer2.add(baseAnimation2, forKey: "baseanimation2")
        arrows2Layer.add(keyAnimation2, forKey: "keyAnimation2");
        arrows1.add(keyAnimation1, forKey: "keyAnimation1");
        
    }
    
    private func installAnimation(baseAnimation: CABasicAnimation) {
        baseAnimation.fromValue = Double.pi * 2;
        baseAnimation.toValue = 0;
        baseAnimation.duration = 2.5;
        baseAnimation.repeatCount = HUGE;
        //kCAMediaTimingFunctionEaseInEaseOut 使用该值，动画在开始和结束时速度较慢，中间时间段内速度较快。
        baseAnimation.timingFunction =  CAMediaTimingFunction(name:  kCAMediaTimingFunctionEaseOut);
    }
    
    private func installKeyframeAnimation(keyAnimation: CAKeyframeAnimation, values: [Any]) {
        keyAnimation.values = values;
        keyAnimation.keyTimes = [0.1,0.2,0.3,0.4,0.5];
        keyAnimation.autoreverses = false;
        keyAnimation.repeatCount = HUGE;
        keyAnimation.duration = 2.5;
    }
}


























