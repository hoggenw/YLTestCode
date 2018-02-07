//
//  ViewController.swift
//  YLSwiftProtocolTest
//
//  Created by 王留根 on 17/2/24.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit
import YLSwiftScan

protocol TestProtocol: class {
    func needAchieve() ->String
    func notNeedAchieve() ->String
}

protocol putInProtocol: class {
    func input(name: String) -> Void
}
protocol putOutProtocol: class {
    func output(name: String) -> Void
}

extension TestProtocol {
    func notNeedAchieve() ->String {
        return " 不需要实现"
    }
   
}

class ViewController: UIViewController {

     weak var delegate: putInProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let templet: ObjectTemple = ObjectTemple();
        templet.delegate = self;
        self.delegate = templet as putInProtocol;
        if let delegate = self.delegate {
            delegate.input(name: "这就是命啊");
        }
        print("\(needAchieve())")
        print("\(notNeedAchieve())")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: putOutProtocol {
    func output(name: String) {
        print("name : \(name)");
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

