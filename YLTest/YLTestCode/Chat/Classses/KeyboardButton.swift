//
//  KeyboardButton.swift
//  YLTestCode
//
//  Created by 王留根 on 2017/9/21.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

class KeyboardButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame);
        self.titleLabel?.textAlignment = .center;
        self.imageView?.contentMode = .scaleAspectFill;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageWH: CGFloat = 36;
        let imageX: CGFloat = (contentRect.size.width - imageWH) * 0.5;
        let imageY: CGFloat = contentRect.size.height - 19 - imageWH;
        return CGRect(x: imageX, y: imageY, width: imageWH, height: imageWH)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleY =   (self.imageView?.frame.maxY)! + 7   //CGRectGetMaxY((self.imageView?.frame)!) + 7;
        return CGRect(x: 0, y: titleY, width: contentRect.size.width, height: 12)
    }
    
}
