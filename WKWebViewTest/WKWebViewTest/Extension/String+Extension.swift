//
//  String+Extension.swift
//  AESTest
//
//  Created by 王留根 on 17/3/6.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import Foundation
import UIKit

//fileprivate let IVString = "xxxxxxxxxxxxxxxxx"
//public extension String {
//    
//    func aesEncrypt(key:String,_ iv:String = IVString, options:Int = kCCOptionPKCS7Padding) -> String? {
//        if let keyData = key.data(using: String.Encoding.utf8),
//            let data = self.data(using: String.Encoding.utf8),
//            let cryptData    = NSMutableData(length: Int((data.count)) + kCCBlockSizeAES128) {
//            
//            let keyLength              = size_t(kCCKeySizeAES128)
//            let operation: CCOperation = UInt32(kCCEncrypt)
//            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
//            let options:   CCOptions   = UInt32(options)
//            
//            var numBytesEncrypted :size_t = 0
//            
//            let cryptStatus = CCCrypt(operation,
//                                      algoritm,
//                                      options,
//                                      keyData.bytes, keyLength,
//                                      iv,
//                                      data.bytes, data.count,
//                                      cryptData.mutableBytes, cryptData.length,
//                                      &numBytesEncrypted)
//            
//            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
//                cryptData.length = Int(numBytesEncrypted)
//                let base64cryptString = cryptData.base64EncodedString(options: .endLineWithLineFeed)
//                return base64cryptString
//            }
//            else {
//                return nil
//            }
//        }
//        return nil
//    }
//    
//    
//    func aesDecrypt(key:String, iv:String = IVString, options:Int = kCCOptionPKCS7Padding) -> String? {
//        if let keyData = key.data(using: String.Encoding.utf8),
//            let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters),
//            let cryptData    = NSMutableData(length: Int((data.length)) + kCCBlockSizeAES128) {
//            
//            let keyLength              = size_t(kCCKeySizeAES128)
//            let operation: CCOperation = UInt32(kCCDecrypt)
//            let algoritm:  CCAlgorithm = UInt32(kCCAlgorithmAES128)
//            let options:   CCOptions   = UInt32(options)
//            
//            var numBytesEncrypted :size_t = 0
//            
//            let cryptStatus = CCCrypt(operation,
//                                      algoritm,
//                                      options,
//                                      keyData.bytes, keyLength,
//                                      iv,
//                                      data.bytes, data.length,
//                                      cryptData.mutableBytes, cryptData.length,
//                                      &numBytesEncrypted)
//            
//            if UInt32(cryptStatus) == UInt32(kCCSuccess) {
//                cryptData.length = Int(numBytesEncrypted)
//                let unencryptedMessage = String(data: cryptData as Data, encoding:String.Encoding.utf8)
//                return unencryptedMessage
//            }
//            else {
//                return nil
//            }
//        }
//        return nil
//    }
//    
//    var md5:String {
//        let str = cString(using: String.Encoding.utf8)
//        let strLen = CC_LONG(lengthOfBytes(using: String.Encoding.utf8))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//        
//        CC_MD5(str!, strLen, result)
//        
//        let hash = NSMutableString()
//        for i in 0..<digestLen {
//            hash.appendFormat("%02x", result[i])
//        }
//        
//        result.deallocate(capacity: digestLen)
//        
//        return String(format: hash as String)
//    }
//    
//}

public extension String {
    
    subscript (r: Range<String.Index>)-> String {
        get {
            return substring(with: r)
        }
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    func substring(with r:Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: Range(uncheckedBounds: (lower: startIndex, upper: endIndex)))
    }
    
    func size(maxSize: CGSize, font: UIFont, lineMargin: CGFloat = 0) -> CGSize {
        let options: NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineMargin // 行间距
        
        var attributes = [String : Any]()
        attributes[NSFontAttributeName] = font
        attributes[NSParagraphStyleAttributeName] = paragraphStyle
        
        let str = self as NSString
        let textBounds = str.boundingRect(with: maxSize, options: options, attributes: attributes, context: nil)
        
        return textBounds.size

    }
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func toFloat() -> Float? {
        return NumberFormatter().number(from: self)?.floatValue
    }
    
    func toInt() -> Int? {
        return NumberFormatter().number(from: self)?.intValue
    }
    
    func isEmptyWithoutWhitespacesAndNewlines() -> Bool {
        if isEmpty {
            return true
        }
        return 0 == trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).characters.count
    }
    
}

public extension String {
    // 正则匹配判断
    func isMatchRegex(_ regex:String) -> Bool {
        let predicate =  NSPredicate(format: "SELF MATCHES %@" , regex)
        return predicate.evaluate(with: self)
    }
    // 是否是电话号码
    func isPhoneNum() -> Bool {
        
        let regex = "^1\\d{10}$"
        return self.isMatchRegex(regex)
    }
    //身份证号码判断
    func isIdentityForChina() -> Bool {
        let regex = "^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$"
        return self.isMatchRegex(regex)
    }
}


public extension String {
    
    func length() -> Int {
        return self.characters.count;
    }
    
    func convertStringToDictionary() -> [String:AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}

extension Data {
    public var bytes:UnsafeRawPointer{
        return (self as NSData).bytes
    }
}
































