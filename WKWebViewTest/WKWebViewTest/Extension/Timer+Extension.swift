//
//  Timer+Extension.swift
//  YLTestCode
//
//  Created by 王留根 on 17/3/28.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import Foundation

public extension Timer {
    
    func pause() {
        if self.isValid {
            self.fireDate = Date.distantFuture
        }
    }
    
    func resume() {
        if self.isValid {
            self.fireDate = Date()
        }
    }
    
    func resumeAfter(interval: TimeInterval) {
        if self.isValid {
            self.fireDate = Date(timeIntervalSinceNow: interval)
        }
    }
}
