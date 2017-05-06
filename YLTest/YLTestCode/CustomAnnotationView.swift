//
//  CustomAnnotationView.swift
//  YLTestCode
//
//  Created by 王留根 on 2017/5/5.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

class CustomAnnotationView: MAAnnotationView {
    public var calloutView: CustomCalloutView?
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        if selected {
            if calloutView == nil {
                calloutView = CustomCalloutView(frame: CGRect(x: 0, y: 0, width: 200, height: 70));
                calloutView!.center = CGPoint(x: self.bounds.width / 2 + self.calloutOffset.x, y: -self.bounds.height / 2 + self.calloutOffset.y);
                calloutView!.portraitView.image = UIImage(named: "test");
                calloutView!.titlelabel.text = self.annotation.title;
                calloutView!.subtitleLabel.text = self.annotation.subtitle;
                self.addSubview(calloutView!)
            }
        }else {
            calloutView?.removeFromSuperview();
        }
        super.setSelected(selected, animated: animated);
    }

}
