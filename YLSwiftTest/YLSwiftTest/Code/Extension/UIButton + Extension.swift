//
//  UIButton + Extension.swift
//  YLTestCode
//
//  Created by 王留根 on 17/3/30.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

public extension UIButton
{
    
    
    
     func setTitle(_ title: String?, _ titleColor: UIColor, for state: UIControl.State, _ font: UIFont? = nil, _ bgImage: UIImage? = nil) -> Void {
        self.setTitle(title, for: state)
        self.setTitleColor(titleColor, for: state)
        self.setBackgroundImage(bgImage, for: state)
        self.titleLabel?.font = font
    }
    
    // MARK: - Initialization Function
    convenience init(title: String?, font: UIFont, titleColor: UIColor) {
        self.init(type: .custom)
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .selected)
        self.titleLabel?.font = font
        self.setTitleColor(titleColor, for: .normal)
        self.setTitleColor(titleColor, for: .selected)
    }
    
    
    
    
    
    
}
