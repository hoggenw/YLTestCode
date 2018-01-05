//
//  ViewController.swift
//  YLMetalTest
//
//  Created by 王留根 on 2018/1/4.
//  Copyright © 2018年 王留根. All rights reserved.
//

import UIKit
import Metal

class ViewController: UIViewController {

    var metalDevice:MTLDevice! = nil;
    override func viewDidLoad() {
        super.viewDidLoad()
        metalDevice = MTLCreateSystemDefaultDevice();
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

