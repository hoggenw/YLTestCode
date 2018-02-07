//
//  YLCircleView.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/2/7.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLCircleView.h"
#import "ExtensionHeader.h"

@interface YLCircleView ()

@property (nonatomic,assign) CGFloat lineWidth;
@property (nonatomic,strong) UIColor * lineColor;
@property (nonatomic,assign) float  size;

@end

@implementation YLCircleView

- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth lindeColor:(UIColor *)lineColor size:(CGFloat)size
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineWidth = lineWidth;
        self.lineColor = lineColor;
        self.size = size;
        self.layer.cornerRadius = self.width / 2;
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.circleLayer = [CAShapeLayer new];
    self.circleLayer.lineWidth = self.lineWidth*0.5;
    self.circleLayer.fillColor = nil;
    self.circleLayer.strokeColor = self.lineColor.CGColor;
    self.circleLayer.frame = self.bounds;
    self.circleLayer.lineCap = kCALineCapRound;
    self.circleLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.height/2) radius:self.width*self.size startAngle:0 endAngle: M_PI * 2 clockwise:YES].CGPath;
    [self.layer addSublayer:self.circleLayer];
    
}

@end
