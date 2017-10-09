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
        view.backgroundColor = UIColor.white;
        progressView =  CircleView(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
        progressView.center = self.view.center;
        self.view.addSubview( progressView);
        progressView.beginAnimation();
        //progressView.startProgress(progress: 0, totalTimer: Double(3))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
