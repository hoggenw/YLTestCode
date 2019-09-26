//
//  LanguageUtil.swift
//  YLSwiftTest
//
//  Created by 王留根 on 2019/9/16.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

import UIKit

class LanguageUtil: NSObject {
    public static  func  languageForKey(key: String) -> String {
        let laguageType = String(format: "%@", UserDefaults.standard.string(forKey: "appLanguage") ?? "");
        let path:String = Bundle.main.path(forResource: laguageType, ofType: "lproj") ?? "";
        let result:String = Bundle.init(path: path)?.localizedString(forKey: key, value: nil, table: "Localizable") ?? "";
        return result;
    }
}

struct YLDeviceUtil {
    public static func isiPhoneXLater() -> Bool {
        
        guard  #available(iOS 11.0, *) else {
            return false;
        }
        return (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > CGFloat(0)) ? true : false;
    }
}
