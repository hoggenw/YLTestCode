//
//  CircleAnimationViewController.swift
//  YLAnimationTest
//
//  Created by 王留根 on 2017/10/9.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

class CircleAnimationViewController: UIViewController {
    //持有进度条
    open var progressView: CircleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton()
        button.backgroundColor = UIColor.brown
        button.frame = CGRect(x: 120, y: 100, width: 60, height: 50)
        button.setTitle("开始动画", for: .normal)
        button.addTarget(self, action: #selector(animationAction), for: .touchUpInside)
        self.view.addSubview(button)
        view.backgroundColor = UIColor.white;
        progressView =  CircleView(frame: CGRect(x: 100, y: 200, width: 80, height: 80))
        progressView.center = self.view.center;
        self.view.addSubview( progressView);
        
        //progressView.startProgress(progress: 0, totalTimer: Double(3))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animationAction() {
        progressView.beginAnimation();
    }
    

}
