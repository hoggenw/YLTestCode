//
//  KeyboardEmojiModel.swift
//  YLTestCode
//
//  Created by 王留根 on 2017/9/19.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit
import ObjectMapper

class KeyboardEmojiModel: Mappable {
    
    /** 当前表情对应的文件夹名称 */
    var group_folder_name: String? = "";
    
    /** 当前表情对应的字符串 */
    var name: String = "";
    
    /** 当前表情对应的图片 */
    var gif: String = "";
    
    /** 生成当前表情图片的绝对路径 */
    var imagePath: String?{
        get {
            if (self.group_folder_name?.length())! > 0 {
                return Bundle.main.path(forResource: self.gif, ofType: nil)!;
            }
            return nil;
        }
        set {
            
        }
  
    }
    
    /** Emoji表情对应的字符串 */
    var code: String? {
        get {
            var backString: String? = nil;
            let array: [String] = self.name.components(separatedBy: "[");
            if array.count > 0 {
                let lastArray: [String] = array.last!.components(separatedBy: "]");
                backString = lastArray.first!;
            }
            return backString;
        }
        
        set {
            
        }
    }
    
    /** Emoji表情处理之后的字符串 */
    var emojiStr: String = "";
    
    /** 记录是否是删除表情 */
    var isRemoveButton: Bool = false;
    
    /** 记录当前表情使用的次数 */
    var count: NSInteger = 0;
    
    init() {
        
    }
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        
        group_folder_name   <- map["group_folder_name"];
        name                <- map["name"];
        gif                 <- map["gif"];
        imagePath           <- map["imagePath"];
        code                <- map["code"];
        emojiStr            <- map["emojiStr"];
        isRemoveButton      <- map["isRemoveButton"];
        count               <- map["count"];

    }
    
    

}
