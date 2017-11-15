//
//  DrawerView.swift
//  YLAnimationTest
//
//  Created by 王留根 on 2017/11/9.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

class DrawerView: UIView {
    
    //http://www.jianshu.com/p/1c8ef3116b42
    //CAGradientlayer可以绘制一个充满整个图层的颜色梯度(包括原型图层等图层)在一个背景颜色上
    /**
     // 创建阶梯图层
     let gradientLayer = CAGradientLayer()
     // 设置阶梯图层的背景
     //gradientLayer.backgroundColor = UIColor.grayColor().CGColor
     // 图层的颜色空间(阶梯显示时按照数组的顺序显示渐进色)
     gradientLayer.colors = [UIColor.redColor().CGColor,UIColor.blueColor().CGColor,UIColor.greenColor().CGColor]
     // 各个阶梯的区间百分比
     gradientLayer.locations = [0.1,0.6,1]
     gradientLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)
     gradientLayer.position = self.view.center
     // 绘图的起点(默认是(0.5,0))
     gradientLayer.startPoint = CGPointMake(1, 0)
     // 绘图的终点(默认是(0.5,1))
     ![Uploading (0,0.5)(1,0.5)@2x_114834.png . . .]
     
     gradientLayer.endPoint = CGPointMake(0, 1)
     self.view.layer.addSublayer(gradientLayer)
     }
     */
    var containView : UIView!
    var containHelperView: UIView!
    var rota: CGFloat?
    var gradLayer: CAGradientLayer!
    var open: Bool = false;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        containView = UIView(frame: CGRect(x: 50, y: 0, width: frame.size.width, height: frame.size.height));
        containHelperView = UIView(frame: CGRect(x: 50, y: 0, width: frame.size.width, height: frame.size.height));
        self.addSubview( containView);
        containView .backgroundColor = UIColor.orange;
        
        gradLayer = CAGradientLayer.init();
        gradLayer.frame = containView.bounds;
        gradLayer.colors = [UIColor.clear.cgColor,UIColor.black.withAlphaComponent(0.5).cgColor];
        gradLayer.startPoint = CGPoint(x: 0, y: 0.5);
        gradLayer.endPoint = CGPoint(x: 1, y: 0.5);
        gradLayer.locations = [0.2,1];
        containView.layer.addSublayer(gradLayer);
        self.backgroundColor = UIColor.black;
        initialTrans();
        intialUI();
    }
    
    func intialUI()  {
        let titleLabel = creatLabel();
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 64);
        titleLabel.text = "题目";
        titleLabel.backgroundColor = UIColor.green;
        containView.addSubview( titleLabel);
        titleLabel.addLineWithSide(.inBottom, color: UIColor.black, thickness: 0.5, margin1: 0, margin2: 0);
        
        let listLabel = creatLabel();
        listLabel.frame = CGRect(x: 0, y: 64, width: self.frame.size.width, height: 64);
        listLabel.text = "内容一";
        containView.addSubview( listLabel);
        
    }
    
    func creatLabel() ->UILabel {
        let label = UILabel();
        label.font = UIFont.systemFont(ofSize: 15);
        label.textColor = UIColor.white;
        label.textAlignment = .center;
        
        return label;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func initialTrans() {
        var tran = CATransform3DIdentity;
        tran.m34 = -1/500.0;
        /**
         //contaTran沿Y轴翻转是在tran的基础之上
         CATransform3D contaTran = CATransform3DRotate(tran,-M_PI_2, 0, 1, 0);
         
         //初始的位置是被折叠起来的，也就是上面的contaTran变换是沿着右侧翻转过去，但是我们需要翻转之后的位置是贴着屏幕左侧，于是需要一个位移
         CATransform3D contaTran2 = CATransform3DMakeTranslation(-self.frame.size.width, 0, 0);
         //两个变换的叠加
         _containView.layer.transform = CATransform3DConcat(contaTran, contaTran2);
         */
        
        //  沿着sidebar区域的右侧翻转比较简单，设置layer的anchorPoint为(1,0.5)即可。
        containView.layer.anchorPoint = CGPoint(x: 1, y: 0.5);
        let contaTRan = CATransform3DRotate(tran, -CGFloat(Double.pi/Double(2)), 0, 1, 0);////(后面3个 数字分别代表不同的轴来翻转，本处为y轴)-CGFloat(Double.pi/Double(2))控制反转方向
        //CATransform3DMakeTranslation实现以初始位置为基准,在x轴方向上平移x单位,在y轴方向上平移y单位,在z轴方向上平移z单位
        let contaTran2 = CATransform3DMakeTranslation(-self.frame.size.width, 0, 0);
        containView.layer.transform = CATransform3DConcat(contaTRan, contaTran2);
        containHelperView.layer.anchorPoint = CGPoint(x: 1, y: 0.5);
        containHelperView.layer.transform = contaTRan;
        
    }
    
    func closeeFold() {
        open = false;
    }
    
    func openFold() {
        open = true;
        var tran = CATransform3DIdentity;
        tran.m34 = -1/500.0;

        let tranAni = CABasicAnimation(keyPath: "transform");
        tranAni.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn);
        tranAni.fromValue = NSValue.init(caTransform3D: containView.layer.transform);
        tranAni.toValue = NSValue.init(caTransform3D: tran);
        tranAni.duration = 0.5;
        containView.layer.add(tranAni, forKey: "openForContainAni");
        containView.layer.transform = tran;
        containHelperView.layer.transform = tran;
        

        
    }
    
    open func doOpenOrNot() {
        
        if open {
            closeeFold();
        }else{
           
            openFold();
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}



























