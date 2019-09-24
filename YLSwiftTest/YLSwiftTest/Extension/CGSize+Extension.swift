//
//  CGSize+Extension.swift
//  YLTestCode
//
//  Created by 王留根 on 17/3/30.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import Foundation
import UIKit

public extension CGSize
{
    static var max: CGSize {
        get{
            return CGSize.init(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        }
    }
    
}
