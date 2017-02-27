//
//  HomeModels.swift
//  YLingFM
//
//  Created by 王留根 on 17/2/27.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

class HomeModels: NSObject {

}

public class TestModel : NSObject {
    dynamic var testNumber: Int = 0 {
        didSet {
            testString = String(format: "changed number = %d", testNumber)
        }
    }
    var testString: String? {
        didSet {
            print("\(testString)")
        }
    }
}
