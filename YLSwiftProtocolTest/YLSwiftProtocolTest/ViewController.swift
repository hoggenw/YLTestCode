//
//  ViewController.swift
//  YLSwiftProtocolTest
//
//  Created by 王留根 on 17/2/24.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

protocol TestProtocol: class {
    func needAchieve() ->String
    func notNeedAchieve() ->String
}

extension TestProtocol {
    func notNeedAchieve() ->String {
        return " 不需要实现"
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(needAchieve())")
        print("\(notNeedAchieve())")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: TestProtocol {
    
    func needAchieve() -> String {
        return "必学实现"
    }
//    func notNeedAchieve() -> String {
//        return "****"
//    }
    
}

