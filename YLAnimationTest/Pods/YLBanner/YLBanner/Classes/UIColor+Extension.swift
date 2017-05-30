//
//  UIColor+Extension.swift
//  SwiftQJT
//
//  Created by 王留根 on 16/9/7.
//  Copyright © 2016年 ios-mac. All rights reserved.
//

import UIKit

extension UIColor {
    

    class  func colorWithHex(hexRGBValue:NSInteger) -> UIColor {
        return UIColor.init(red:CGFloat(((hexRGBValue & 0xFF0000)>>16))/255.0, green: CGFloat(((hexRGBValue & 0xFF00)>>8))/255.0, blue: CGFloat((hexRGBValue & 0xFF))/255.0, alpha: 1.0)
    }
    
}
