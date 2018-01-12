//
//  ObjectTemple.swift
//  YLSwiftProtocolTest
//
//  Created by 王留根 on 2018/1/12.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

import UIKit

class ObjectTemple: NSObject {
     weak var delegate: putOutProtocol?

}

extension ObjectTemple : putInProtocol{
    func input(name: String) {
        if let delegate = self.delegate {
            delegate.output(name: "极限挑战: " + name);
        }
    }
}
