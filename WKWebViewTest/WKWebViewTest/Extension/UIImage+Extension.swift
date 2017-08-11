//
//  UIImage+Extension.swift
//  YLTestCode
//
//  Created by 王留根 on 17/3/28.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

extension UIImage {
    
    public class func imageWith(color: UIColor)-> UIImage {
        let imageW: CGFloat = 1
        let imageH: CGFloat = 1
        // 1.开启基于位图的图形上下文
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageW, height: imageH), false, 0.0)
        
        // 2.画一个color颜色的矩形框
        color.set()
        UIRectFill(CGRect(x: 0, y: 0, width: imageW, height: imageH))
        
        // 3.拿到图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 4.关闭上下文
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    // 根据图片的中心点去拉伸图片并返回
    public func resizableImageWithCenterPoint() -> UIImage
    {
        let top = self.size.height * 0.5 - 1.0      // 顶端盖高度
        let bottom = top                            // 底端
        let left = self.size.width * 0.5 - 1.0      // 左
        let right = left                            // 右
        let insets = UIEdgeInsets.init(top: top, left: left, bottom: bottom, right: right)
        let image = self.resizableImage(withCapInsets: insets, resizingMode: UIImageResizingMode.stretch)
        return image;
    }
    
    public func tinedImage(color:UIColor,level:Float = 1) -> UIImage {
        
        return tinedImage(color: color, rect: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height), level: level)
    }
    
    public func tinedImage(color:UIColor,rect:CGRect,level:Float = 1) -> UIImage {
        
        let imageRect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, self.scale)
        let ctx = UIGraphicsGetCurrentContext()
        draw(in: imageRect)
        ctx?.setFillColor(color.cgColor)
        ctx?.setAlpha(CGFloat(level))
        ctx?.setBlendMode(.sourceAtop)
        ctx?.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        if newImage == nil {
            return self
        }
        return newImage!
    }
}
