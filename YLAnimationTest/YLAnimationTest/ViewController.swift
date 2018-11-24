//
//  ViewController.swift
//  YLAnimationTest
//
//  Created by 王留根 on 2017/5/23.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit
import YLSwiftScan

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialUI();
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialUI() {
        self.view.backgroundColor = UIColor.white;
//        let button = UIButton()
//        button.backgroundColor = UIColor.brown
//        button.frame = CGRect(x: self.view.bounds.width/2 - 30, y: self.view.bounds.height/2 - 200, width: 60, height: 50)
//        button.setTitle("circleAnimation", for: .normal)
//
//        button.addTarget(self, action: #selector(circleAnimationAction), for: .touchUpInside)
//        self.view.addSubview(button)
//
//        let button1 = UIButton()
//        button1.backgroundColor = UIColor.brown
//        button1.frame = CGRect(x: self.view.bounds.width/2 - 30, y: self.view.bounds.height/2 - 100, width: 60, height: 50)
//        button1.setTitle("波浪", for: .normal)
//        button1.addTarget(self, action: #selector(waveAnimationAction), for: .touchUpInside)
//        self.view.addSubview(button1)
//
//
//        let button2 = UIButton()
//        button2.backgroundColor = UIColor.brown
//        button2.frame = CGRect(x: self.view.bounds.width/2 - 30, y: self.view.bounds.height/2 , width: 60, height: 50)
//        button2.setTitle("3D", for: .normal)
//        button2.addTarget(self, action: #selector(Animation3DAction), for: .touchUpInside)
//        self.view.addSubview(button2)
//
//        let button3 = UIButton()
//        button3.backgroundColor = UIColor.brown
//        button3.frame = CGRect(x: self.view.bounds.width/2 - 30, y: self.view.bounds.height/2 + 100 , width: 60, height: 50)
//        button3.setTitle("3D_Optimization", for: .normal)
//        button3.addTarget(self, action: #selector(Animation3DViewAction), for: .touchUpInside)
//        self.view.addSubview(button3)
//
//        //voiceInputViewAction
//
//        let button4 = UIButton()
//        button4.backgroundColor = UIColor.brown
//        button4.frame = CGRect(x: self.view.bounds.width/2 - 30, y: self.view.bounds.height/2 + 200 , width: 60, height: 50)
//        button4.setTitle("voiceInput", for: .normal)
//        button4.addTarget(self, action: #selector(voiceInputViewAction), for: .touchUpInside)
//        self.view.addSubview(button4)
//
//
//        for index in 0 ..< addOne.count {
//            print("changed number " +  String.init(format: "%d", addOne[index]) );
//        }
//
        let button2 = UIButton()
        button2.backgroundColor = UIColor.brown
        button2.frame = CGRect(x: view.bounds.size.width/2 - 30, y: view.bounds.size.height/2 , width: 60, height: 50)
        button2.setTitle("录制", for: .normal)
        button2.titleLabel?.textColor = UIColor.white
        self.view.addSubview(button2)
        button2.addTarget(self, action: #selector(QR), for: .touchUpInside)
//
//        let button3 = UIButton()
//        button3.backgroundColor = UIColor.brown
//        button3.frame = CGRect(x: view.bounds.size.width/2 - 30, y: view.bounds.size.height/2 + 100 , width: 60, height: 50)
//        button3.setTitle("地图", for: .normal)
//        button3.titleLabel?.textColor = UIColor.white
//        self.view.addSubview(button3)
//        button3.addTarget(self, action: #selector(button3Action), for: .touchUpInside)
//
//        let button4 = UIButton()
//        button4.backgroundColor = UIColor.brown
//        button4.frame = CGRect(x: view.bounds.size.width/2 - 30, y: view.bounds.size.height/2 + 200 , width: 60, height: 50)
//        button4.setTitle("跳转", for: .normal)
//        button4.titleLabel?.textColor = UIColor.white
//        self.view.addSubview(button4)
//        button4.addTarget(self, action: #selector(drawMap), for: .touchUpInside)
        self.view.backgroundColor = UIColor.white;
    }
    
    func QR()  {
        //初始化
        let manager = YLScanViewManager.shareManager()
        //视图UI相关的设置更改，可以不做设置，使用默认配置
        // 是否需要边框
        //manager.isNeedShowRetangle = true
        //扫描框的宽高比
        // manager.whRatio = 1
        //相对中心点Y的偏移
        //manager.centerUpOffset = -20
        //扫描框的宽度
        // manager.scanViewWidth = 160
        //扫描框的颜色
        //manager.colorRetangleLine = UIColor.red
        //4角与扫描框的位置关系
        //manager.photoframeAngleStyle = YLScanViewPhotoframeAngleStyle.Outer
        //扫描框4角的颜色
        //manager.colorAngle = UIColor.red
        //扫码区域4个角的线条宽度
        //manager.photoframeLineW = 4
        //扫描动画的样式，自带4种样式
        // manager.imageStyle = YLAnimationImageStyle.secondeNetGrid
        //自定义扫描动画
        //manager.animationImage = image
        //添加扫描成功返回代理
        manager.delegate = self
        //显示(viewController要求有UINavigationController)
        manager.showScanView(viewController: self)
    }
    
    func circleAnimationAction() {
        let circleVC = CircleAnimationViewController()
        self.navigationController?.pushViewController( circleVC, animated:  true);
    }
    
    func waveAnimationAction() {
        let waveVC = WaveViewController()
        self.navigationController?.pushViewController( waveVC, animated:  true);
    }
    
    func Animation3DAction() {
        let transform3DVC = DrawerViewController();
        self.navigationController?.pushViewController( transform3DVC, animated:  true);
    }
    
    func Animation3DViewAction() {
        let transform3DVC = Menu3DViewController();
        self.navigationController?.pushViewController( transform3DVC, animated:  true);
    }
    func voiceInputViewAction() {
        let voiceInputVC = YLVoirceInputViewController();
        self.navigationController?.pushViewController( voiceInputVC, animated:  true);
    }


}

extension ViewController :YLScanViewManagerDelegate {
    func scanSuccessWith(result: YLScanResult) {
        print("wlg====%@",result.strScanned!)
    }
}



