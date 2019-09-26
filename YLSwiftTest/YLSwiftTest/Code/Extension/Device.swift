//
//  Device.swift
//  YLTestCode
//
//  Created by 王留根 on 17/3/30.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

public class Device {
    static func isPhone4() -> Bool {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        return width <= 320 && height <= 480
    }
    
    static func isPhone5() -> Bool {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        return width <= 320 && height > 480
    }
    
    static func isPhone6() -> Bool {
        let width = UIScreen.main.bounds.width
        return width > 320 && width < 414
    }
    
    static func isPhone6Plus() -> Bool {
        let width = UIScreen.main.bounds.width
        return width >= 414
    }
    
}
