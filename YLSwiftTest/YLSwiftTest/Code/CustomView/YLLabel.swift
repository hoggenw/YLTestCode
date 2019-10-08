//
//  YLLabel.swift
//  YLSwiftTest
//
//  Created by 王留根 on 2019/9/30.
//  Copyright © 2019 hoggen.com. All rights reserved.
//

import UIKit

class YLLabel: UILabel {
    
    let edgeInsets:UIEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10);

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = super.textRect(forBounds:bounds.inset(by: edgeInsets), limitedToNumberOfLines: numberOfLines);
        rect.origin.x -= self.edgeInsets.left;
        rect.origin.y -= self.edgeInsets.right;
        rect.size.width += self.edgeInsets.left + self.edgeInsets.right;
        rect.size.height += self.edgeInsets.top + self.edgeInsets.bottom;
        return rect;
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: self.edgeInsets));
    }

}
