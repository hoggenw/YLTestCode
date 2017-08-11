//
//  Array+Extension .swift
//  YLTestCode
//
//  Created by 王留根 on 17/3/29.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import Foundation

extension Array {
    
    func safeElement(index: Int) ->Element? {
        if index >= 0 && index < self.count {
            return self[index]
        }
        return nil
    }
    
    func toJSONString() -> String? {
        
        if JSONSerialization.isValidJSONObject(self) {
            do {
                let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.init(rawValue: 0))
                return String(data: data, encoding: String.Encoding.utf8)
            } catch {
                print("toJSONString is failed")
            }
        }
        return ""
    }
}
