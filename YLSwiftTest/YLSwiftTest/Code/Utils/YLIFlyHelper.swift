//
//  YLIFlyHelper.swift
//  YLSwiftTest
//
//  Created by 王留根 on 2019/9/26.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

import Foundation

public struct YLIFlyHelper {
    static func makeConfiguration(){
        //IFlySetting.setLogFile(LOG_LEVEL.LVL_LOW);
        IFlySetting.showLogcat(false);
        let cachePath = FileManagerUtil.getCachePath();
        IFlySetting.setLogFilePath(cachePath);
        let initString = String(format: "appid=%@", USER_APPID);
        IFlySpeechUtility.createUtility(initString);
        
        
    }
}
