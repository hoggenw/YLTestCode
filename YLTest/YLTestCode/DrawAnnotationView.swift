//
//  DrawAnnotationView.swift
//  YLTestCode
//
//  Created by 王留根 on 2017/5/17.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

class DrawAnnotationView: MAAnnotationView {

    override init!(annotation: MAAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
