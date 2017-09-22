//
//  KeyboardEmojiPackage.swift
//  YLTestCode
//
//  Created by 王留根 on 2017/9/19.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit
import ObjectMapper

class KeyboardEmojiPackage: Mappable {
    /** 当前组文件夹名称 */
    var group_folder_name: String?;
    
    /** 当前组的名称 */
    var group_name: String?;
    
    /** 当前组所有的表情模型 */
    var emojis: [KeyboardEmojiModel] = [KeyboardEmojiModel]();
    //单例
    public static let shareInstance: KeyboardEmojiPackage = KeyboardEmojiPackage()
    private static  var packages: [KeyboardEmojiPackage] = [KeyboardEmojiPackage]();
    
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        group_folder_name   <- map["group_folder_name"];
        group_name          <- map["group_name"];
        emojis              <- map["emojis"];
        
    }
    
    class func getPackages() -> [KeyboardEmojiPackage]  {
        return self.packages;
    }
    
    class func loadPackages() -> [KeyboardEmojiPackage]  {
        let packge = KeyboardEmojiPackage();
        var models: [KeyboardEmojiPackage] = [KeyboardEmojiPackage]()
        let path: String = Bundle.main.path(forResource: "emoticons.plist", ofType: nil)!;
        let dict: NSDictionary = NSDictionary.init(contentsOfFile: path)!;
        let array: [[String: String]] = dict.value(forKey: "packages") as! [[String : String]];
        for temp in array {
            let package: KeyboardEmojiPackage = Mapper<KeyboardEmojiPackage>().map(JSON: temp)!
            packge.loadEmojis();
            packge.appendEmptyEmoji();
            models.append(package)
        }
        self.packages = models;
        return self.packages;
    }
    
    
    /**
     *  加载当前组所有的表情
     */
    func loadEmojis () {
        let path: String = Bundle.main.path(forResource: self.group_name, ofType: nil)!;
        let array: [[String: Any]] = NSArray.init(contentsOfFile: path)! as! [[String : Any]];
        var models = [KeyboardEmojiModel]();
        for temp:[String: Any] in array {
            let emotion: KeyboardEmojiModel = Mapper<KeyboardEmojiModel>().map(JSON: temp)!;
            emotion.group_folder_name = self.group_folder_name;
            models.append(emotion);
        }
        self.emojis  = models;
    }
    
    /**
     根据字符串查找表情模型
     
     - parameter str: 指定字符串
     
     - returns: 表情模型
     */
    func findEmoji(string: String ) -> KeyboardEmojiModel? {
        var emotion: KeyboardEmojiModel? = nil;
        for temp in KeyboardEmojiPackage.loadPackages() {
            let array: [KeyboardEmojiModel] = temp.emojis.filter({ (model) -> Bool in
                return model.name == string;
            })
            if array.count > 0  {
                emotion = array.first;
                break;
            }
        }
        
        return emotion
        
    }
    
    func  attributedString(string: String, font: UIFont) -> NSAttributedString {
        let stringNS: NSString = string as NSString;
        let pattern: NSString = "\\[\\w+\\]";
        let regex: NSRegularExpression = try! NSRegularExpression(pattern: pattern as String, options: .caseInsensitive)
        let array: NSArray = regex.matches(in: string, options: .reportProgress, range: NSRange.init(location: 0, length: stringNS.length)) as NSArray
        var stringM: NSMutableAttributedString = NSMutableAttributedString.init(string: string);
        
        var index = array.count;
        while index > 0 {
            index = index - 1;
            let result: NSTextCheckingResult = array[index] as! NSTextCheckingResult;
            let temp: String = stringNS.substring(with: result.range);
            let emotion: KeyboardEmojiModel? = self.findEmoji(string: temp);
            if emotion == nil {
                continue;
            }
            let attrString: NSAttributedString = KeyboardEmojiAttachment.emojiString(emoji: emotion!, font: font);
            stringM.replaceCharacters(in: result.range, with: attrString);
            
        }
        
        return stringM;
        
    }
    
    
    /**
     *  追加空白按钮, 当当前组的数据不能被8整除时, 就追加空白按钮, 让当前组能够被8整除
     */
    
    func appendEmptyEmoji() {
        let count: NSInteger = self.emojis.count % 8;
        guard count > 0 else {
            return
        }
        
        for _ in count...7 {
            self.emojis.append(KeyboardEmojiModel());
        }
        
    }
    
}
