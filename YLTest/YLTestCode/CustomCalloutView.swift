//
//  CustomCalloutView.swift
//  YLTestCode
//
//  Created by 王留根 on 2017/5/5.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

import UIKit

class CustomCalloutView: UIView {
    
    public var portraitView: UIImageView!
    public var subtitleLabel: UILabel!
    public var titlelabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.clear;
        initSubViews();
        
    }
    func initSubViews() {
        self.portraitView = UIImageView(frame: CGRect(x: 5, y: 5, width: 70, height: 50))
        portraitView.backgroundColor = UIColor.black;
        self.addSubview(portraitView);
        titlelabel = UILabel(frame: CGRect(x: 10 + 70, y: 5, width: 120, height: 20));
        titlelabel.font = UIFont.boldSystemFont(ofSize: 14);
        titlelabel.textColor = UIColor.white;
        titlelabel.text = "something say title";
        self.addSubview(titlelabel)
        subtitleLabel = UILabel(frame: CGRect(x: 10 + 70, y: 30, width: 120, height: 20));
        subtitleLabel.font = UIFont.systemFont(ofSize: 12);
        subtitleLabel.textColor = UIColor.lightGray;
        subtitleLabel.text = "afhkshfksahflaskfsdnlkasjflaks rubish";
        self.addSubview(subtitleLabel);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func draw(_ rect: CGRect) {
        self.drawInContext(context: UIGraphicsGetCurrentContext()!);
        self.layer.shadowColor = UIColor.black.cgColor;
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
    
    func drawInContext(context: CGContext) {
        context.setLineWidth(2.0);
        context.setFillColor(UIColor.coloreWithRGB(red: 77, green: 77, blue: 77, alpha: 0.3).cgColor);
        self.getDrawPath(context: context);
        context.fillPath();

    }
    
    func getDrawPath(context: CGContext){
        let rrect = self.bounds;
        let radius:CGFloat = 6.0;
        let minx:CGFloat = rrect.minX
        let midx:CGFloat = rrect.midX;
        let maxx:CGFloat = rrect.maxX;
        let miny:CGFloat = rrect.minY;
        let maxy:CGFloat = rrect.maxY - 10;
        context.move(to: CGPoint(x: midx + 10, y: maxy));
        context.addLine(to:  CGPoint(x: midx + 10, y: maxy + 10))
        context.addLine(to:  CGPoint(x: midx - 10, y: maxy));
        
        context.addArc(tangent1End:  CGPoint(x: minx, y: maxy), tangent2End:  CGPoint(x: midx, y: miny), radius: radius);
        context.addArc(tangent1End:  CGPoint(x: minx, y:minx), tangent2End:  CGPoint(x: maxx, y: miny), radius: radius);
        context.addArc(tangent1End:  CGPoint(x: maxx, y: miny), tangent2End:  CGPoint(x: maxx , y: maxx), radius: radius);
        context.addArc(tangent1End:  CGPoint(x: maxx, y: maxy), tangent2End:  CGPoint(x: midx, y: maxy), radius: radius);
        context.closePath();
    }
}


















