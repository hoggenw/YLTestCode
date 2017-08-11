//
//  Dictionary+Extension.swift
//  YLTestCode
//
//  Created by 王留根 on 17/3/30.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import Foundation

public extension Dictionary {
    
    func convertDictionaryToData() -> Data? {
        var result:Data?
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            result = jsonData;
            //            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
            //                result = JSONString
            //            }
            
        } catch {
            print("convert dictionary To string error")
        }
        return result
    }
    
    func dataToDictionary(data:Data) ->[String : AnyObject]?{
        
        do{
            
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            let dic: [String: AnyObject] = json as! [String : AnyObject]
            
            return dic
            
        }catch {
            
            print("失败")
            
            return nil;
            
        }
        
    }
    
    func JSONString() -> String {
        
        if JSONSerialization.isValidJSONObject(self) {
            do {
                let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.init(rawValue: 0))
                if let string = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            } catch {
                
            }
        }
        return ""
    }
}
