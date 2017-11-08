//
//  WaveView.swift
//  YLAnimationTest
//
//  Created by 王留根 on 2017/11/8.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit


class WaveView: UIView {

    var caLink: CADisplayLink?
    var offset: CGFloat = 0;
    var speed: CGFloat = 0;
    let layerA: CALayer = CALayer();
    let layerB: CALayer = CALayer();
    var waveWidth: CGFloat = 0;
    var waveHight: CGFloat = 30.0;

    
    override init(frame: CGRect) {
        super.init(frame: frame);
        waveWidth = self.frame.size.width;
        
        layerA.opacity = 0.5;
        layerA.frame = self.bounds;
        layerB.frame = self.bounds;
        layerB.opacity = 0.5;
        self.layer.addSublayer(layerA);
        self.layer.addSublayer(layerB);
        
    }
    
    func doAnimation() {
        offset += speed;
        
    }
    
    func animationBegin() {
        if caLink == nil {
           caLink = CADisplayLink(target: self, selector: #selector(animationAction));
        }
        
        caLink!.add(to: RunLoop.current, forMode: .commonModes);
    }
    
    func animationStop() {
        caLink!.invalidate();
        caLink = nil;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationAction() {
        
    }
    
}
