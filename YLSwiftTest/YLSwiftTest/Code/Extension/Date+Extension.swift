//
//  Date+Extension.swift
//  YLTestCode
//
//  Created by 王留根 on 17/3/30.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import Foundation

//private let MINUTE = 60
//private let HOUR  = (60 * MINUTE)
//private let DAY   = (24 * HOUR)
//private let WEEK  = (7 * DAY)
//private let MONTH = (30 * DAY)
//private let YEAR  = (365 * DAY)

public extension Date{
    
    


    // 格式化输出时间  使用UTC时区表示时间  如：yyyy-MM-dd HH:mm:ss
    func DateToString(with format: String? = "yyyy-MM-dd HH:mm", in timeZone: TimeZone? = TimeZone.current) -> String {
        
        let dateFormatter = DateFormatter()
        // 设置 格式化样式
        dateFormatter.dateFormat = format
        // 设置时区
        dateFormatter.timeZone = timeZone
        
        let strDate = dateFormatter.string(from: self)
        return strDate
        
    }
    func formatDayOfYear() -> String {
        return formatDate(format: "yyyy-MM-dd");
    }
    
    func formatWeekday() -> String {
        return formatDate(format: "EEEE");
    }
    
    
    func formatHourAndMinute() -> String {
        return formatDate(format: "HH:mm");
    }
    
    func formatYYMMDDHHMMSS() -> String {
        return formatDate(format: "yyyy-MM-dd HH:mm:ss");
    }
    
    func formatMonthAndDay() -> String {
        return formatDate(format: "MM月dd日");
    }
    
    
    func formatMMDDHHMM() -> String {
        return formatDate(format: "MM-dd HH:mm");
    }
    
    
    func formatMMDD() -> String {
        return formatDate(format: "MM-dd");
    }
    
    func formatDate(format: String) -> String {
        let formatter =  DateFormatter();
        formatter.dateFormat = format;
        return formatter.string(from: self);
    }
    
}
