//
//  KeyboardEmojiTextView.swift
//  YLTestCode
//
//  Created by 王留根 on 2017/9/21.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

class KeyboardEmojiTextView: UITextView {
    
    public var insertEmojiTextBlock : ((_ textView: UITextView)-> Void)?

    /**
     插入表情文字
     
     - parameter emoji: 需要插入的表情模型
     */
    func insertEmojiText(emoji: KeyboardEmojiModel) {
        self.text = self.text.appending(emoji.name);
        if self.insertEmojiTextBlock != nil {
            self.insertEmojiTextBlock!(self);
        }
    }
    
    /**
     插入表情
     
     - parameter emoji: 需要插入的表情模型
     */
    func insertEmoji(emoji: KeyboardEmojiModel ) {
        let temp = emoji.emojiStr;
        if temp == "\0" {
            self.replace(self.selectedTextRange!, withText: temp);
        }
        if emoji.imagePath != nil {
            let stringM: NSMutableAttributedString = NSMutableAttributedString(attributedString: self.attributedText);
            let emojiStr: NSAttributedString = KeyboardEmojiAttachment.emojiString(emoji: emoji, font: UIFont.systemFont(ofSize: 16));
            let range : NSRange = self.selectedRange(selectedRange: self.selectedTextRange!);
            stringM.replaceCharacters(in: range, with: emojiStr)
            stringM.addAttributes([NSFontAttributeName: self.font as Any], range: NSMakeRange(range.location, 1));
            self.attributedText = stringM;
            self.selectedTextRange = self.toTextRange(range:  NSMakeRange(range.location + 1, 0))
            return
        }
        
    }
    func toTextRange(range: NSRange) -> UITextRange {
     let beginging = self.beginningOfDocument;
        let start: UITextPosition = self.position(from: beginging, offset:  range.location)!;
        let end: UITextPosition = self.position(from: start, offset:  range.length)!;
        return self.textRange(from: start, to: end)!;
    }
    
    func selectedRange(selectedRange: UITextRange) -> NSRange {
        let beginging = self.beginningOfDocument;
        let selectionStart = selectedRange.start;
        let selectionEnd = selectedRange.end;
        let loaction = self.offset(from: beginging, to: selectionStart);
        let length = self.offset(from: selectionStart, to: selectionEnd);
        return NSMakeRange(loaction, length);
    }
 
    
    /**
     获取属性字符串对应的文本字符串
     
     - returns: 文本字符串
     */
    func emojiString() -> String? {
        var returnString: NSString? = ""
        self.attributedText.enumerateAttributes(in: NSMakeRange(0, self.attributedText.length), options: .reverse) { (attrs, range, stop) in
            if attrs["NSAttachment"] != nil {
                let attachment: KeyboardEmojiAttachment = attrs["NSAttachment"] as! KeyboardEmojiAttachment;
                returnString = returnString?.appending(attachment.chs!) as NSString?
            }else {
                returnString = returnString?.appending((self.attributedText.string as NSString).substring(with: range)) as NSString?
            }
        }
        
        return returnString as String?
    }

}
