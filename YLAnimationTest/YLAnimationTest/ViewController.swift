//
//  ViewController.swift
//  YLAnimationTest
//
//  Created by 王留根 on 2017/5/23.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

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
        let button = UIButton()
        button.backgroundColor = UIColor.brown
        button.frame = CGRect(x: self.view.bounds.width/2 - 30, y: self.view.bounds.height/2 - 200, width: 60, height: 50)
        button.setTitle("circleAnimation", for: .normal)
//        let leftmargin: CGFloat = 0
//        let rightmargin: CGFloat = 0
        button.addTarget(self, action: #selector(circleAnimationAction), for: .touchUpInside)
//        button.addLineWithSide(.inBottom, color: .red, thickness: 3, margin1: leftmargin, margin2: rightmargin)
//        button.addLineWithSide(.inLeft, color: UIColor.randomColor(), thickness: 3, margin1: leftmargin, margin2: rightmargin)
//        button.addLineWithSide(.outBottom, color: .red, thickness: 3, margin1: leftmargin, margin2: rightmargin)
//        button.addLineWithSide(.outLeft, color: UIColor.randomColor(), thickness: 3, margin1: leftmargin, margin2: rightmargin)
        self.view.addSubview(button)
        
//        let button1 = UIButton()
//        button1.backgroundColor = UIColor.brown
//        button1.frame = CGRect(x: self.view.bounds.width/2 - 30, y: self.view.bounds.height/2 - 100, width: 60, height: 50)
//        button1.setTitle("生成", for: .normal)
//        button1.addTarget(self, action: #selector(creatSelfQRcODE), for: .touchUpInside)
//        self.view.addSubview(button1)
//
//
//        for index in 0 ..< addOne.count {
//            print("changed number " +  String.init(format: "%d", addOne[index]) );
//        }
//
//        let button2 = UIButton()
//        button2.backgroundColor = UIColor.brown
//        button2.frame = CGRect(x: view.bounds.size.width/2 - 30, y: view.bounds.size.height/2 , width: 60, height: 50)
//        button2.setTitle("录制", for: .normal)
//        button2.titleLabel?.textColor = UIColor.white
//        self.view.addSubview(button2)
//        button2.addTarget(self, action: #selector(turnToRecordController), for: .touchUpInside)
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
    
    func circleAnimationAction() {
        let circleVC = CircleAnimationViewController()
        self.navigationController?.pushViewController( circleVC, animated:  true);
    }


}

