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
    var offset2: CGFloat = 0;
    var speed: CGFloat = 0;
    var speed2: CGFloat = 0;
    let layerA: CAShapeLayer = CAShapeLayer();
    let layerB: CAShapeLayer = CAShapeLayer();
    var waveWidth: CGFloat = 0;
    var waveHight: CGFloat = 8.0;
    var waveHight2: CGFloat = 5.0;
    var standerPonitY: CGFloat?;

    
    override init(frame: CGRect) {
        super.init(frame: frame);
        waveWidth = self.frame.size.width;
        layerA.opacity = 0.5;
        layerA.frame = self.bounds;
        layerB.frame = self.bounds;
        layerB.opacity = 0.5;
        standerPonitY = self.frame.size.height/2;
        speed = 3;
        speed2 = 3;
        //waveHight = self.frame.size.height/5;
        self.layer.addSublayer(layerA);
        self.layer.addSublayer(layerB);
        
    }
    
    func doAnimation() {
       
        offset += speed;
        offset2 += speed2;
        
        let pathRef: CGMutablePath = CGMutablePath();
        let startY = waveHight * CGFloat(sinf(Float(offset*CGFloat(Double.pi)/waveWidth))) + standerPonitY!;
        pathRef.move(to: CGPoint(x: 0.0, y: startY));
        let viewWidth: Int = Int(waveWidth);
        for  i in 0 ... viewWidth {
            //
            let Y: CGFloat = waveHight * CGFloat(sinf(Float(CGFloat(Double.pi * 2.5) / waveWidth * CGFloat(i) + offset*CGFloat(Double.pi)/waveWidth))) +  standerPonitY! ;
            pathRef.addLine(to: CGPoint(x: CGFloat(i), y: Y))
        }
        
        pathRef.addLine(to: CGPoint(x: waveWidth, y: self.frame.size.height));
        pathRef.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
        pathRef.closeSubpath();
        layerA.path = pathRef;
        
        let pathRefB: CGMutablePath = CGMutablePath();
        let startYB = waveHight2 * CGFloat(sinf(Float(offset2 * CGFloat(Double.pi)/waveWidth) + Float(Double.pi/4))) + standerPonitY!;
        pathRefB.move(to: CGPoint(x: 0.0, y: startYB));
        for  i in 0 ... viewWidth {
            let YB: CGFloat = waveHight2 * CGFloat(sinf(Float(CGFloat(Double.pi * 4) / waveWidth * CGFloat(i) + offset2*CGFloat(Double.pi)/waveWidth) + Float(Double.pi/4))) +  standerPonitY! ;
            pathRefB.addLine(to: CGPoint(x: CGFloat(i), y: YB))
        }
        pathRefB.addLine(to: CGPoint(x: waveWidth, y: self.frame.size.height));
        pathRefB.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
        pathRefB.closeSubpath();
        layerB.path = pathRefB;
        
        
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
        doAnimation();
    }
    
}
