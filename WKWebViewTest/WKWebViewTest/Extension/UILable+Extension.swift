//
//  UILable+Extension.swift
//  YLTestCode
//
//  Created by 王留根 on 17/3/30.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

public extension UILabel
{
    
    // MARK: - Initialization Function
    public convenience init(font: UIFont? ,backgroundColor: UIColor? , textColor: UIColor?,alignment: NSTextAlignment? , text: String? ) {
        self.init()
        if let fontW = font {
            self.font = fontW
        }
        if let backColor = backgroundColor {
            self.backgroundColor = backColor
        }
        if let textColorW = textColor {
            self.textColor = textColorW
        }
        if let alignmentW = alignment {
            self.textAlignment = alignmentW
        }
        
        if let textW = text {
            self.text = textW
        }
        
    }
    
    public convenience init(text: String?, font: UIFont, textColor: UIColor, alignment: NSTextAlignment = .left) {
        self.init()
        self.textColor = textColor
        self.font = font
        self.text = text
        self.textAlignment = alignment
    }
    
    
}
