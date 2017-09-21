//
//  UIColor+Extension.swift
//  YLTestCode
//
//  Created by 王留根 on 17/3/28.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

public extension UIColor {
    
    public convenience init(hex: UInt32) {
        self.init(hex:hex, alpha:1.0)
    }
    
    public convenience init(hex: UInt32, alpha: CGFloat) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red,green: green, blue: blue, alpha: alpha)
    }
    
    public convenience init(_ red: UInt8, _ green: UInt8, _ blue: UInt8) {
        self.init(R: red, G: green, B: blue, A: 1.0)
    }
    
    public convenience init(R: UInt8, G: UInt8, B: UInt8, A alapha: CGFloat = 1) {
        let red = CGFloat(R) / 255.0
        let green = CGFloat(G) / 255.0
        let blue = CGFloat(B) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alapha)
    }
    
    
    public static func colorWith(hexRGBValue:UInt32, alpha:CGFloat) -> UIColor {
        return UIColor.init(hex: hexRGBValue,alpha: alpha)
    }
    
    public static func colorWith(hexRGBValue:UInt32) -> UIColor {
        return UIColor.init(hex: hexRGBValue)
    }
    
    public static func coloreWithRGB(red: UInt8, green: UInt8, blue: UInt8, alpha: CGFloat) -> UIColor {
        return UIColor.init(R: red, G: green, B: blue, A: alpha)
    }
    
    public static func coloreWithRGB(red: UInt8, green: UInt8, blue: UInt8) -> UIColor {
        return UIColor.init(R: red, G: green, B: blue, A: 1)
    }
    
    // randomColor
    public static func randomColor() -> UIColor {
        
        let randR = CGFloat(arc4random_uniform(256)) / CGFloat(255.0)
        let randG = CGFloat(arc4random_uniform(256)) / CGFloat(255.0)
        let randB = CGFloat(arc4random_uniform(256)) / CGFloat(255.0)
        return UIColor.init(red: randR, green: randG, blue: randB, alpha: 1)
    }
    
}
