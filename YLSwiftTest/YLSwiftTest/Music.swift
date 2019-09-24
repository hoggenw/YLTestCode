//
//  Music.swift
//  YLSwiftTest
//
//  Created by 王留根 on 2019/9/16.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

import UIKit


struct Music {
    let name:String ;
    let singer:String;
    init(name:String,singer:String) {
        self.name = name;
        self.singer = singer;
    }
    
}

extension Music: CustomStringConvertible{
    var description: String{
        return "name:\(name) signer: \(singer)";
    }
}
