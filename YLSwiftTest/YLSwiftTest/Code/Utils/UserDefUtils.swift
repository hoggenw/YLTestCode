//
//  UserDefUtils.swift
//  YLSwiftTest
//
//  Created by 王留根 on 2019/9/26.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

import Foundation

public struct UserDefUtils {
    static func saveDictionary(dictionary:[String:Any],for  key: String) {
        let userDef = UserDefaults.standard;
        let json = dictionary.convertDictionaryToData();
        userDef.set(json, forKey: key);
        userDef.synchronize();
    }
    
    static func getDictionaryForKey(key: String) ->[String:Any]? {
        let userDef = UserDefaults.standard;
        let json = userDef.data(forKey: key);
        var returnDictionary:[String:Any] = Dictionary.init();
        if let _ = json?.count {
            returnDictionary = returnDictionary.dataToDictionary(data: json!)!;
        }
        userDef.synchronize();
        return returnDictionary;
    }
    
    static func saveArray(saveArray:[Any],for  key: String) {
        let userDef = UserDefaults.standard;
        userDef.set(saveArray, forKey: key);
        userDef.synchronize();
    }
    
    static func getArrayForKey(key: String) ->[Any]? {
        let userDef = UserDefaults.standard;
        let getArray = userDef.array(forKey: key);
        return getArray;
    }
    
    static func saveString(saveString:String,for  key: String) {
        let userDef = UserDefaults.standard;
        userDef.set(saveArray, forKey: key);
        userDef.synchronize();
    }
    
    static func getStringForKey(key: String) ->String {
        let userDef = UserDefaults.standard;
        guard let string = userDef.string(forKey: key) else { return "" };
        return string;
    }
    
}
