//
//  VioceInputView.swift
//  YLAnimationTest
//
//  Created by 王留根 on 2018/1/31.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

import UIKit

class VioceInputView: UIView {

    var circle: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        initUI()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initUI() {
        circle =  UIView(frame: CGRect(x: 80, y: 100, width: 100, height: 100));
        circle.backgroundColor = UIColor.lightGray;
        self.addSubview(circle);
        
        //创建背景圆环
        let trackLayer = CAShapeLayer();
        trackLayer.frame = circle.bounds;
        //清空填充色
        trackLayer.fillColor = UIColor.clear.cgColor;
        //设置画笔颜色 即圆环背景色
        trackLayer.strokeColor =  UIColor.green.cgColor;
        trackLayer.lineWidth = 20;
        //设置画笔路径
        let startAngle = Double.pi;
        let endAngle = startAngle + Double.pi * 0.8;
        
        let width = circle.frame.size.width;
        let borderWidth = circle.layer.borderWidth;
        
        let path = UIBezierPath(arcCenter: CGPoint(x: width/2, y: width/2), radius: width/2 - borderWidth, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise:  true);
        
        path.lineWidth     = borderWidth
        path.lineJoinStyle = .round //终点处理
        //path 决定layer将被渲染成何种形状
        trackLayer.path = path.cgPath;
        circle.layer.addSublayer(trackLayer);
        
        
        let gradientLayer = CALayer();
        gradientLayer.frame = circle.bounds;
        
        let gradientLayer1 = CAGradientLayer();
        gradientLayer1.frame = circle.bounds;
        gradientLayer1.colors = [UIColor.green.cgColor,UIColor.lightGray.cgColor];
        //startPoint和endPoint属性，他们决定了渐变的方向。这两个参数是以单位坐标系进行的定义，所以左上角坐标是{0, 0}，右下角坐标是{1, 1}
        //startPoint和pointEnd 分别指定颜色变换的起始位置和结束位置.
        //当开始和结束的点的x值相同时, 颜色渐变的方向为纵向变化
        //当开始和结束的点的y值相同时, 颜色渐变的方向为横向变化
        //其余的 颜色沿着对角线方向变化
        gradientLayer1.startPoint = CGPoint(x: 0, y: 0);
        gradientLayer1.endPoint = CGPoint(x: 1, y: 1);
        gradientLayer.addSublayer(gradientLayer1);
        
        let trackLayer1 = CAShapeLayer();
        trackLayer1.frame = circle.bounds;
        //清空填充色
        trackLayer1.fillColor = UIColor.clear.cgColor;
        //设置画笔颜色 即圆环背景色
        trackLayer1.strokeColor =  UIColor.blue.cgColor;
        trackLayer1.lineWidth = 20;

        gradientLayer1.mask = trackLayer1;
        
        circle.layer.addSublayer(gradientLayer);
        
        

    }

}
