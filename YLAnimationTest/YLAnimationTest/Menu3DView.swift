//
//  Menu3DView.swift
//  YLAnimationTest
//
//  Created by 王留根 on 2017/11/16.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

class Menu3DView: UIView {
    
    //展示视图
    let navView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 64));
    let menuButton = UIButton();
    var backGroudView: UIView!
    var tvView: UIView!
    
    //翻转视图
    let sideMenu = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: ScreenHeight));
    var containView : UIView!
    var containHelperView: UIView!
    var gradLayer: CAGradientLayer!
    
    //判断参数
    var _rota: CGFloat?
    var ifOpen: Bool = false;

    override init(frame: CGRect) {
        super.init(frame: frame);
        intialUI();
        intialSideMenu();
        intialSideMenuUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func intialSideMenu() {
        containView = UIView(frame: CGRect(x: 50, y: 0, width: sideMenu.frame.size.width, height: sideMenu.frame.size.height));
        containHelperView = UIView(frame: CGRect(x: 50, y: 0, width: sideMenu.frame.size.width, height: sideMenu.frame.size.height));
        sideMenu.addSubview( containView);
        containView .backgroundColor = UIColor.orange;
        
        gradLayer = CAGradientLayer.init();
        gradLayer.frame = containView.bounds;
        gradLayer.colors = [UIColor.clear.cgColor,UIColor.black.withAlphaComponent(0.5).cgColor];
        gradLayer.startPoint = CGPoint(x: 0, y: 0.5);
        gradLayer.endPoint = CGPoint(x: 1, y: 0.5);
        gradLayer.locations = [0.2,1];
        containView.layer.addSublayer(gradLayer);
        sideMenu.backgroundColor = UIColor.black;
        
    }
    
    func intialSideMenuUI()  {
        let titleLabel = creatLabel();
        titleLabel.frame = CGRect(x: 0, y: 0, width: containView.frame.size.width, height: 64);
        titleLabel.text = "题目";
        titleLabel.backgroundColor = UIColor.green;
        containView.addSubview( titleLabel);
        titleLabel.addLineWithSide(.inBottom, color: UIColor.black, thickness: 0.5, margin1: 0, margin2: 0);
        
        let listLabel = creatLabel();
        listLabel.frame = CGRect(x: 0, y: 64, width: containView.frame.size.width, height: 64);
        listLabel.text = "内容一";
        containView.addSubview( listLabel);
        initialTrans();
    }
    func creatLabel() ->UILabel {
        let label = UILabel();
        label.font = UIFont.systemFont(ofSize: 15);
        label.textColor = UIColor.white;
        label.textAlignment = .center;
        
        return label;
    }
    
    func initialTrans() {
        let tran = getTran();
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
        let contaTran2 = CATransform3DMakeTranslation(-sideMenu.frame.size.width, 0, 0);
        containView.layer.transform = CATransform3DConcat(contaTRan, contaTran2);
        containHelperView.layer.anchorPoint = CGPoint(x: 1, y: 0.5);
        containHelperView.layer.transform = contaTRan;
        
    }
    
    func intialUI() {
        backGroudView = UIView(frame: self.bounds);
         self.backGroudView.backgroundColor = UIColor.white;
        tvView = UIView(frame: self.bounds);
        tvView.backgroundColor = UIColor.green;
        navView.backgroundColor = UIColor.brown;
        
        self.addSubview(sideMenu);
        self.addSubview(backGroudView);
        backGroudView.addSubview(tvView);
        backGroudView.addSubview(navView);
        menuButton.frame = CGRect(x: 20, y: 30, width: 64, height: 32);
        menuButton.setImage(getPathImage(), for: .normal);
        navView.addSubview(menuButton);
        menuButton.addTarget(self, action: #selector(openMenu(sender:)), for: .touchUpInside);
    }
    
    
    
    func getTran() -> CATransform3D {
        var tran = CATransform3DIdentity;
        tran.m34 = -1/500.0;
        return tran
    }
    
    
    func openMenu(sender: UIButton) {
        
        if ifOpen {
            close();
        }else{
            open();
        }
        
        
    }
    
    func close() {
        ifOpen = false;
        self.gradLayer.colors = [UIColor.clear.cgColor,UIColor.black.withAlphaComponent(0.5).cgColor];
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(rawValue: UIViewAnimationOptions.RawValue(3 << 10)), animations: {
            self.menuButton.transform = CGAffineTransform.identity;
            self.backGroudView.layer.transform = CATransform3DIdentity;
            self.initialTrans();
        }) { (finish) in
        };
    }
    
    func open() {
        let tran = getTran();
        ifOpen = true;
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(rawValue: UIViewAnimationOptions.RawValue(3 << 10)), animations: {
            self.menuButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2));
        }) { (finish) in
            self.gradLayer.colors = [UIColor.clear.cgColor,UIColor.clear.cgColor];
        };
        let tranAni2 = CABasicAnimation(keyPath: "transform");
        tranAni2.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn);
        tranAni2.fromValue = NSValue.init(caTransform3D: backGroudView.layer.transform);
        tranAni2.toValue = NSValue.init(caTransform3D: CATransform3DMakeTranslation(100, 0, 0));
        tranAni2.duration = 0.5;
        backGroudView.layer.add(tranAni2, forKey: "openForContainerAni");
        backGroudView.layer.transform = CATransform3DMakeTranslation(100, 0, 0);
    
        
        let tranAni = CABasicAnimation(keyPath: "transform");
        tranAni.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn);
        tranAni.fromValue = NSValue.init(caTransform3D: containView.layer.transform);
        tranAni.toValue = NSValue.init(caTransform3D: tran);
        tranAni.duration = 0.5;
        containView.layer.add(tranAni, forKey: "openForContainAni");
        containView.layer.transform = tran;
        containHelperView.layer.transform = tran;
        
    }
    
    func getPath() -> UIBezierPath {
        let path = UIBezierPath();
        path.move(to: CGPoint(x: 4, y: 4));
        path.addLine(to: CGPoint(x: 24, y: 4))
        path.move(to: CGPoint(x: 4, y: 11));
        path.addLine(to: CGPoint(x: 24, y: 11))
        path.move(to: CGPoint(x: 4, y: 18));
        path.addLine(to: CGPoint(x: 24, y: 18))
        return path;
    }
    
    func getPathImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 32, height: 32), false, UIScreen.main.scale);
        let context = UIGraphicsGetCurrentContext();
        context!.addPath(getPath().cgPath);
        context?.setStrokeColor(UIColor.white.cgColor);
        context?.setFillColor(UIColor.black.cgColor);
        context?.setLineWidth(3);
        context?.strokePath();
        context?.fillPath();
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return image;
    }
    
    open func getRato(rato: CGFloat) {
        let tran = getTran();
        var rota: CGFloat = rato;
        if ifOpen == false {
            if rota <= 0 {
                rota = 0;
            }
            if rota > CGFloat(Double.pi/2) {
                rota = CGFloat(Double.pi/2)
            }
            self.menuButton.transform = CGAffineTransform(rotationAngle: rota);
            self.gradLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(((0.5 - rota/2.0) > 0) ? 0.5 - rota/2.0 : 0).cgColor];
            let contaTran = CATransform3DRotate(tran, -CGFloat(Double.pi/Double(2)) + rota, 0, 1, 0);
            self.containHelperView.layer.transform = contaTran;
            let contaTran2 = CATransform3DMakeTranslation(self.containHelperView.frame.size.width - 100, 0, 0);
            self.containView.layer.transform  = CATransform3DConcat(contaTran, contaTran2);
            backGroudView.transform = CGAffineTransform(translationX: self.containHelperView.frame.size.width, y: 0);
            
        }else{
            if rota >= 0 {
                rota = 0;
            }
            if rota < -CGFloat(Double.pi/2) {
                rota = -CGFloat(Double.pi/2)
            }
            self.menuButton.transform = CGAffineTransform(rotationAngle: rota + CGFloat(Double.pi/2));
            self.gradLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent((( -rota/2.0) < 0.5) ?  -rota/2.0 : 0.5).cgColor];
            let contaTran = CATransform3DRotate(tran, rota, 0, 1, 0);
            self.containHelperView.layer.transform = contaTran;
            
            let contaTran2 = CATransform3DMakeTranslation(self.containHelperView.frame.size.width - 100, 0, 0);
            self.containView.layer.transform  = CATransform3DConcat(contaTran, contaTran2);
            backGroudView.transform = CGAffineTransform(translationX: self.containHelperView.frame.size.width, y: 0);
        }
    }
    
    
    open func doAnimation() {
        if ifOpen == false {
            if _rota! > CGFloat(Double.pi/4) {
                open();
            }else{
                close();
            }
        }else{
            if _rota! > -CGFloat(Double.pi/4) {
                open();
            }else{
                close();
            }
        }
    }
    
}




































