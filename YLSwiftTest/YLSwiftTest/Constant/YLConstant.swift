//
//  YLConstant.swift
//  YLSwiftTest
//
//  Created by 王留根 on 2019/9/16.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

import Foundation
import UIKit

public func localized(key:String) -> String {
    return LanguageUtil.languageForKey(key: key);
}

let ifiPhoneXLater:Bool = YLDeviceUtil.isiPhoneXLater();
let kNavigationHeight = ifiPhoneXLater ? 88: 64;
let HEIGHT_STATUSBAR = ifiPhoneXLater ? 44 : 20;

let HEIGHT_TABBAR = 49;

let HEIGHT_NAVBAR = 44;
let ScreenWidth = UIScreen.main.bounds.size.width;
let ScreenHeight = UIScreen.main.bounds.size.height;

