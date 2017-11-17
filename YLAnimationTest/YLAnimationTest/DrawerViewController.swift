//
//  DrawerViewController.swift
//  YLAnimationTest
//
//  Created by 王留根 on 2017/11/9.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.size.width;
let ScreenHeight = UIScreen.main.bounds.size.height;

class DrawerViewController: UIViewController {
    
    let navView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 64));
    let sideMenu = DrawerView.init(frame: CGRect(x: 0, y: 0, width: 100, height: ScreenHeight));
    let menuButton = UIButton();
    
    var ifChanged: Bool = false;
    var containView : UIView!
    var tvView: UIView!
    var _rota: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        containView = UIView(frame: view.bounds);
        tvView = UIView(frame: view.bounds);
        initialNavView();
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action:
            #selector(gestureRecognizer(gesture:))));
        // Do any additional setup after loading the view.
    }
    
    func gestureRecognizer(gesture: UIPanGestureRecognizer) {
        //获取手势在相对指定视图的移动距离，即在X,Y轴上移动的像素，应该是没有正负的，
        //于是考虑用velocityInView:这个方法，这个方法是获取手势在指定视图坐标系统的移动速度，结果发现这个速度是具有方向的，
        /**
         CGPoint velocity = [recognizer velocityInView:recognizer.view];
         if(velocity.x>0) {
         　　//向右滑动
         }else{
             //向左滑动
         }
         */
        if gesture.state == .changed {
            let point = gesture.translation(in: self.view);
            let velocity = gesture.velocity(in: self.view);
            let fullHeight:CGFloat = 80;
            //print("point.x = \(point.x)");//往右为正，往左为负
            let rota: CGFloat = point.x/fullHeight;
            _rota = rota;
            getRota(rota1: rota);
        }
        if gesture.state == .ended || gesture.state == .cancelled {
            doAnimation();
        }
    }
    
    func doAnimation() {
        if ifChanged == false {
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
    
    
    func getRota(rota1: CGFloat) {
        var tran = CATransform3DIdentity;
        tran.m34 = -1/500.0;
        var rota: CGFloat = rota1;
        if ifChanged == false {
            if rota <= 0 {
                rota = 0;
            }
            if rota > CGFloat(Double.pi/2) {
                rota = CGFloat(Double.pi/2)
            }
            self.menuButton.transform = CGAffineTransform(rotationAngle: rota);
            
            self.sideMenu.gradLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(((0.5 - rota/2.0) > 0) ? 0.5 - rota/2.0 : 0).cgColor];
            let contaTran = CATransform3DRotate(tran, -CGFloat(Double.pi/Double(2)) + rota, 0, 1, 0);
            self.sideMenu.containHelperView.layer.transform = contaTran;
        
            let contaTran2 = CATransform3DMakeTranslation(self.sideMenu.containHelperView.frame.size.width - 100, 0, 0);
            self.sideMenu.containView.layer.transform  = CATransform3DConcat(contaTran, contaTran2);
            self.containView.transform = CGAffineTransform(translationX: self.sideMenu.containHelperView.frame.size.width, y: 0);
            //print("x:\(self.sideMenu.containView.frame.origin.x),   y:\(self.sideMenu.containView.frame.origin.y),    width:\(self.sideMenu.containView.frame.size.width),     rota:\(rota),  self.sideMenu.containHelperView.frame.size.width : \(self.sideMenu.containHelperView.frame.size.width)");
            //self.sideMenu.gestureClose(rota: rota);
            
        }else{
            if rota >= 0 {
                rota = 0;
            }
            if rota < -CGFloat(Double.pi/2) {
                rota = -CGFloat(Double.pi/2)
            }
             self.menuButton.transform = CGAffineTransform(rotationAngle: rota + CGFloat(Double.pi/2));
            self.sideMenu.gradLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent((( -rota/2.0) < 0.5) ?  -rota/2.0 : 0.5).cgColor];
            let contaTran = CATransform3DRotate(tran, rota, 0, 1, 0);
            self.sideMenu.containHelperView.layer.transform = contaTran;
            
            let contaTran2 = CATransform3DMakeTranslation(self.sideMenu.containHelperView.frame.size.width - 100, 0, 0);
            self.sideMenu.containView.layer.transform  = CATransform3DConcat(contaTran, contaTran2);
            self.containView.transform = CGAffineTransform(translationX: self.sideMenu.containHelperView.frame.size.width, y: 0);
            //print(" ===x:\(self.sideMenu.containView.frame.origin.x),y:\(self.sideMenu.containView.frame.origin.y),width:\(self.sideMenu.containView.frame.size.width),rota:\(rota)");
            
            
            //self.containView.transform = CGAffineTransform(translationX: self.sideMenu.containHelperView.frame.size.width, y: 0);
            //self.sideMenu.gestureOpen(rota: rota);
        }
        
    }
   
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.navigationBar.isHidden = true;
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        self.navigationController?.navigationBar.isHidden = false;
    }
    
    func initialNavView() {
        containView.backgroundColor = UIColor.white;
        tvView.backgroundColor = UIColor.green;
        navView.backgroundColor = UIColor.brown;
        
        view.addSubview(sideMenu);
        self.view.addSubview(containView);
        containView.addSubview(tvView);
        containView.addSubview(navView);
        
        
        menuButton.frame = CGRect(x: 20, y: 30, width: 64, height: 32);
        menuButton.setImage(getPathImage(), for: .normal);
        navView.addSubview(menuButton);
        menuButton.addTarget(self, action: #selector(openMenu(sender:)), for: .touchUpInside);
        
        
        
    }
    
    
    func openMenu(sender: UIButton) {
        var tran = CATransform3DIdentity;
        tran.m34 = -1/500.0;
        if ifChanged {
            close();
        }else{
            open();
        }
        
        
    }
    
    func close() {
        ifChanged = false;
        self.sideMenu.gradLayer.colors = [UIColor.clear.cgColor,UIColor.black.withAlphaComponent(0.5).cgColor];
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(rawValue: UIViewAnimationOptions.RawValue(3 << 10)), animations: {
            self.menuButton.transform = CGAffineTransform.identity;
            self.containView.layer.transform = CATransform3DIdentity;
            self.sideMenu.initialTrans();
        }) { (finish) in
        };
        self.sideMenu.closeeFold();
    }
    
    func open() {
        ifChanged = true;
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(rawValue: UIViewAnimationOptions.RawValue(3 << 10)), animations: {
            self.menuButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2));
        }) { (finish) in
            self.sideMenu.gradLayer.colors = [UIColor.clear.cgColor,UIColor.clear.cgColor];
        };
        let tranAni2 = CABasicAnimation(keyPath: "transform");
        tranAni2.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn);
        tranAni2.fromValue = NSValue.init(caTransform3D: containView.layer.transform);
        tranAni2.toValue = NSValue.init(caTransform3D: CATransform3DMakeTranslation(100, 0, 0));
        tranAni2.duration = 0.5;
        containView.layer.add(tranAni2, forKey: "openForContainerAni");
        
        containView.layer.transform = CATransform3DMakeTranslation(100, 0, 0);
        self.sideMenu.openFold();
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
    
    /**
     优化想法
         1.所有视图写入一个view中，且操作在view中完成，不在controlller中进行
         2.手势操作通过接口传入
         3.方法通过代理传递出来
     */
    


}





























