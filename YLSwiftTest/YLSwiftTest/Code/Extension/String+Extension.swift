//
//  String+Extension.swift
//  AESTest
//
//  Created by 王留根 on 17/3/6.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import Foundation
import UIKit
// 导入CommonCrypto
import CommonCrypto

fileprivate let IVString = "xxxxxxxxxxxxxxxxx"
public extension String {
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
 
    
}

public extension String {
    
    subscript (r: Range<String.Index>)-> String {
        get {
            return String(self[r]) ;
        }
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    func substring(from: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from);
        let end = self.endIndex;
        return String(self[startIndex..<end]);
    }
    func substring(to: Int) -> String {
         let toIndex = self.index(self.startIndex, offsetBy: to);
        return String(self[..<toIndex]);
    }
    func substring(with r:Range<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound);
        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound);
        return String(self[startIndex..<toIndex]);
    }
    
    func size(maxSize: CGSize, font: UIFont, lineMargin: CGFloat = 0) -> CGSize {
        let options: NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineMargin // 行间距
        
        var attributes = [NSAttributedString.Key : Any]()
        attributes[NSAttributedString.Key.font] = font
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        
        let str = self as NSString
        let textBounds = str.boundingRect(with: maxSize, options: options, attributes: attributes, context: nil);
        
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
/**除掉空格的空字符串判断 */
    func isEmptyWithoutWhitespacesAndNewlines() -> Bool {
        if isEmpty {
            return true
        }
        return 0 == self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count
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
        return self.count;
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
    
    func base64Encoding()->String
    {
        let plainData = self.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    
    /**
     *   base64解码
     */
    func base64Decoding()->String
    {
        let decodedData = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
        return decodedString
    }
    
    var md5:String {
        let str = cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        
        return String(format: hash as String)
    }
}

extension Data {
    public var bytes:UnsafeRawPointer{
        return (self as NSData).bytes
    }
}
































