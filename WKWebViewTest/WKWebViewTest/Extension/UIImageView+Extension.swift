//
//  UIImageView+Extension.swift
//  YLTestCode
//
//  Created by 王留根 on 17/3/30.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit
//import Kingfisher


public extension UIImageView
{
    // MARK: - Initialization Function
    
    public convenience init(imageName: String?, mode: UIViewContentMode = .scaleAspectFill, clipsToBounds: Bool = true) {
        self.init()
        self.contentMode = mode
        self.clipsToBounds = clipsToBounds
        if nil != imageName {
            self.image = UIImage.init(named: imageName!)
        }
    }
    
    
    // Remark: 系统 public init(image: UIImage?)
    public convenience init(placeHolder: UIImage?, mode: UIViewContentMode = .scaleAspectFill, clipsToBounds: Bool = true) {
        self.init()
        self.image = placeHolder
        self.contentMode = mode
        self.clipsToBounds = clipsToBounds
    }
    
    
//    @discardableResult
//    func setImage(with resource: Resource?,
//                  placeholder: Image? = nil,
//                  options: KingfisherOptionsInfo? = nil,
//                  progressBlock: DownloadProgressBlock? = nil,
//                  completionHandler: CompletionHandler? = nil) -> RetrieveImageTask {
//        
//        if resource == nil {
//            self.image = placeholder
//            return self.kf.setImage(with: nil)
//        }
//        return self.kf.setImage(with: resource, placeholder: placeholder, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
//    }
}
