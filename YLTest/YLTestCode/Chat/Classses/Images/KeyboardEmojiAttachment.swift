//
//  KeyboardEmojiAttachment.swift
//  YLTestCode
//
//  Created by 王留根 on 2017/9/19.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit
import WebKit

class KeyboardEmojiAttachment: NSTextAttachment {
    /** 保存当前附件对应的字符串 */
     var chs: String?
    /** 图片 */
    var webImage: UIWebView
    
    override init(data contentData: Data?, ofType uti: String?) {
        webImage = UIWebView();
        super.init(data: contentData, ofType: uti);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func emojiString(emoji: KeyboardEmojiModel, font: UIFont) -> NSAttributedString {
        let attachment: KeyboardEmojiAttachment  = KeyboardEmojiAttachment();
        attachment.image = UIImage(contentsOfFile: emoji.imagePath!);
        attachment.chs = emoji.name;
        let height: CGFloat = CGFloat(font.lineHeight);
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height);
        return NSAttributedString.init(attachment: attachment);
        
    }

   
    

}
