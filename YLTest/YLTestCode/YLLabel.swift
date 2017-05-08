//
//  YLLabel.swift
//  YLWholesale
//
//  Created by 王留根 on 2017/4/14.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

class YLLabel: UILabel {

    var edgesInset : UIEdgeInsets?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.edgesInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.edgesInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, self.edgesInset!), limitedToNumberOfLines: numberOfLines)
        rect.origin.x = rect.origin.x - (self.edgesInset?.left)!
        rect.origin.y = rect.origin.y - (self.edgesInset?.top)!
        rect.size.width = rect.size.width + (self.edgesInset?.left)! + (self.edgesInset?.right)!
        rect.size.height = rect.size.height + (self.edgesInset?.top)! + (self.edgesInset?.bottom)!
        
        
        
        return rect
        
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, self.edgesInset!))
    }

}
