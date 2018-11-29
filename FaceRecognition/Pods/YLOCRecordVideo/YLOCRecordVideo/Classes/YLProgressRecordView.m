//
//  YLProgressView.m
//  ftxmall
//
//  Created by 王留根 on 2017/9/27.
//  Copyright © 2017年 wanthings. All rights reserved.
//

#import "YLProgressRecordView.h"
#import "NSTimer+Extension.h"
#import "UIColor+Extension.h"



@interface YLProgressRecordView ()

@property(nonatomic, strong) CAShapeLayer * shapeLayer;

@property(nonatomic, assign) NSTimeInterval incInterval;

@property(nonatomic, assign) NSTimeInterval totalTimerInterval;
@property(nonatomic, assign) NSTimeInterval totalTime;

@property(nonatomic, assign) CGFloat showProgress;

@property(nonatomic, assign) CGFloat startProgress;

@property(nonatomic, strong) NSTimer * progressTimer;

@property(nonatomic, strong) UILabel * timeLeftLabel;

@end

@implementation YLProgressRecordView

-(void)dealloc {
    if (_progressTimer != nil) {
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.shapeLayer = [[CAShapeLayer alloc] initWithLayer: self.layer];
        [self.layer addSublayer: self.shapeLayer];
        self.shapeLayer.borderWidth = 1;
        self.shapeLayer.lineWidth = 2;
        self.shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        self.shapeLayer.strokeColor = [[UIColor colorWithHexString: @"#2bb3e7"] CGColor];
        self.shapeLayer.borderColor = [[UIColor colorWithHexString: @"#2bb3e7"] CGColor];
        self.incInterval = 0.05;
        self.timeLeftLabel = [UILabel new];
        self.timeLeftLabel.frame = CGRectMake(0, self.shapeLayer.lineWidth, frame.size.width, frame.size.height - self.shapeLayer.lineWidth);
        self.timeLeftLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLeftLabel.textColor = [UIColor whiteColor];
        self.timeLeftLabel.adjustsFontSizeToFitWidth = true;
        [self addSubview: self.timeLeftLabel];
    }
    return  self;
}

-(void)startProgress:(CGFloat) progress totalTimer:(NSTimeInterval )totalTimer{
    self.showProgress = progress;
    self.startProgress = progress;
    self.totalTimerInterval = totalTimer;
    self.totalTime = totalTimer;
    self.timeLeftLabel.text = [NSString stringWithFormat:@"%.0lf″00", totalTimer];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval: _incInterval target: self selector: @selector(timerProgress) userInfo:nil repeats: YES];
    [self.progressTimer resumeTimer];
    //[[NSTimer alloc] initWithFireDate:[NSDate date] interval: _incInterval target: self selector:@selector(timerProgress) userInfo:nil repeats: YES];
}
    
-(void)timerProgress {
    self.totalTimerInterval = self.totalTimerInterval - self.incInterval ;
    self.showProgress = self.showProgress -  self.startProgress * (self.incInterval/self.totalTime);
    
    NSInteger second =  ((NSInteger )(self.totalTimerInterval * 100)) / 100;
    NSInteger microsecond = ((NSInteger )(self.totalTimerInterval * 100)) % 100;
    self.timeLeftLabel.text = [NSString stringWithFormat:@"%@″%2d", @(second),microsecond];
    //NSLog(@"self.showProgress: %@  ===  self.timeLeftLabel.text : %@ ===self.totalTimerInterval:%@", @(self.showProgress),self.timeLeftLabel.text,@(self.totalTimerInterval));
    [self update: self.showProgress];
    if (self.totalTimerInterval < 0) {
        [self stopProgress];
        [self postNotification];
    }
}

-(void)postNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YLProgressTimeOver" object:nil];
}

- (void)stopProgress {
    if (_progressTimer != nil) {
        [_progressTimer invalidate];
        _progressTimer = nil;
        self.timeLeftLabel.text = @"";
        [self update: 0];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.shapeLayer.cornerRadius = self.frame.size.width / 2.0;
    self.shapeLayer.path = [[self layooutPath] CGPath];
}

- (void)update:(CGFloat) progress {
    [CATransaction begin];
    [CATransaction setValue: (id)kCFBooleanTrue forKey: kCATransactionDisableActions];
    self.shapeLayer.strokeEnd = 1 - (1 - progress)/2;
    self.shapeLayer.strokeStart = 1 - self.shapeLayer.strokeEnd;
    [CATransaction commit];
}

-(UIBezierPath *)layooutPath {
//    double Two_M_pI = 2.0 * M_PI;
//    double startAngle = 0.75 * Two_M_pI;
//    double endAngle = startAngle + Two_M_pI;
    
    CGFloat width = self.frame.size.width;
    CGFloat  borderWidth = self.shapeLayer.borderWidth;
    UIBezierPath * path = [UIBezierPath new];
    path.lineWidth = borderWidth;
    path.lineJoinStyle = kCGLineJoinRound;
    [path moveToPoint: CGPointMake(0, -2)];
    [path addLineToPoint:CGPointMake(width, -2)];
    
    
    return path;

}

@end























