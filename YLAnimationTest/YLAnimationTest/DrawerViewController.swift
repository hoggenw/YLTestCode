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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        containView = UIView(frame: view.bounds);
        tvView = UIView(frame: view.bounds);
        initialNavView();
        // Do any additional setup after loading the view.
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
            ifChanged = false;
            self.sideMenu.gradLayer.colors = [UIColor.clear.cgColor,UIColor.black.withAlphaComponent(0.5).cgColor];
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(rawValue: UIViewAnimationOptions.RawValue(3 << 10)), animations: {
                self.menuButton.transform = CGAffineTransform.identity;
                self.containView.layer.transform = CATransform3DIdentity;
                self.sideMenu.initialTrans();
            }) { (finish) in
            };
            
            
        }else{
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
            
        }
        
        self.sideMenu.doOpenOrNot();
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
    


}





























