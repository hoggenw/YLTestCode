//
//  UIResponder+Extension.swift
//  YLSwiftTest
//
//  Created by 王留根 on 2019/9/24.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

import UIKit


public extension UIResponder {
    
    func routerEventWithName(name:String,userInfo:Dictionary<String, Any>) {
        self.next?.routerEventWithName(name: name, userInfo: userInfo);
    }
    
}
