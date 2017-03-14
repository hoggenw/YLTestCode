//
//  TapLabel.swift
//  QianJiWang
//
//  Created by 王留根 on 17/3/14.
//  Copyright © 2017年 Pisen. All rights reserved.
//

import UIKit

class TapLabel: UILabel {

    func tapIn(string: String,block: ((Bool)->Void)) {
        guard let attributedSting = self.attributedText, attributedSting.length > 0 else {
            return
        }

    }
    
    func needResponseTouchLabel(point: CGPoint) -> CFIndex {
    
        var point = point
        let bounds = self.bounds
        if !bounds.contains(point) {
            return NSNotFound
        }
        var textRect: CGRect = self.textRect(forBounds: bounds, limitedToNumberOfLines: self.numberOfLines)
        textRect.size = CGSize(width: textRect.size.width, height: textRect.size.height)
        let pathRect: CGRect = CGRect(x: textRect.origin.x, y: textRect.origin.y, width:  textRect.size.width, height: textRect.size.height)
        if !pathRect.contains(point) {
            return NSNotFound
        }
        
        point = CGPoint(x: point.x - textRect.origin.x - 5, y: pathRect.size.height - point.y - textRect.origin.y)
        let path: CGMutablePath =  CGMutablePath()
        
        return NSNotFound
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        
        if needResponseTouchLabel(point: location!) == NSNotFound {
            self.next?.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesMoved(touches, with: event)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesCancelled(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesEnded(touches, with: event)
    }
}
