//
//  YLVoiceCircleView.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/2/5.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLVoiceCircleView.h"
#import "ExtensionHeader.h"
#import "YLCircleView.h"
#import "MicrophoneView.h"


@interface YLVoiceCircleView ()

@property(nonatomic,strong)MicrophoneView * microphoneView;


/**
 状态label
 */
@property (nonatomic,strong) UILabel *statusLabel;

@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)float count;

/**
 *  线宽
 */
@property (nonatomic,assign) CGFloat lineWidth;
/**
 *  线的颜色
 */
@property (nonatomic,strong) UIColor * lineColor;
/**
 *  话筒颜色
 */
@property (nonatomic,strong) UIColor * colidColor;


@property (nonatomic,strong) CAShapeLayer * circleLayer;
@property (nonatomic, weak) UIWindow *window ;

@end

@implementation YLVoiceCircleView



- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.4;
    frame = CGRectMake(100, 100, width, width);
    self.window = [[UIApplication sharedApplication].delegate window];
    CGRect newFrame = frame;
    CGFloat min = (newFrame.size.width >= newFrame.size.height )?newFrame.size.width:newFrame.size.height;
    newFrame.size.width = min;
    newFrame.size.height = min;
    self = [super initWithFrame:CGRectMake(0, 0, newFrame.size.width, newFrame.size.height)];
    if (self) {
        [self creatBackGroundView: newFrame];
        self.lineColor = [UIColor greenColor];
        self.colidColor = self.lineColor;
        self.count = 0;
        self.layer.cornerRadius = self.width/2;
        self.clipsToBounds = true;
        self.backgroundColor = [[UIColor brownColor] colorWithAlphaComponent:0.8];
        [self.backGroundView addSubview: self];
        [self initLineWidth];
        [self addMicrophoneView];
        [self setup];
        
    }
    return self;
}

- (void)setup {
    self.circleLayer = [CAShapeLayer new];
    self.circleLayer.lineWidth = self.lineWidth*0.5;
    self.circleLayer.fillColor = nil;
    self.circleLayer.strokeColor = self.lineColor.CGColor;
    self.circleLayer.frame = self.bounds;
    self.circleLayer.lineCap = kCALineCapRound;
    self.circleLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.height/2) radius: self.width/2 * 0.95 startAngle: 0 endAngle: M_PI * 2 clockwise: true].CGPath;
    [self.layer addSublayer: self.circleLayer];
}

- (void)initLineWidth{
    if (self.width <= 50) {
        self.lineWidth = 1.5;
    }else if (self.width <= 100){
        self.lineWidth = 2;
    }else if (self.width <= 200){
        self.lineWidth = 4;
    }else if (self.width <= 300){
        self.lineWidth = 4.5;
    }else{
        self.lineWidth = 6;
    }
    
}

- (void)addMicrophoneView {
    
    self.microphoneView = [[MicrophoneView alloc] initColorAndLineWidthWithRect: CGRectMake(self.width*0.3, self.height*0.4, self.width*0.4, self.height*0.5) voiceColor: [UIColor cyanColor] volumeColor: self.colidColor isColid: true lineWidth: self.lineWidth];
    [self addSubview: self.microphoneView];
    [self addSubview: self.statusLabel];
}


//开始动画
- (void)startAnimation {
    self.statusLabel.textColor = [UIColor greenColor];
    self.statusLabel.font = [UIFont systemFontOfSize: 13];
    self.statusLabel.text = @"正在聆听...";
    [self.timer resumeTimer];
}

- (void)startARCTopAnimation {

    [self createLayerWayTwo:1.f];
    [self createLayerWayTwo:1.75f];
}

- (void)stopArcAnimation{
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.font = [UIFont systemFontOfSize: 14];
    self.statusLabel.text = @"还没声音";
    [self.timer pauseTimer];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.count = 0;
    

    
}

- (void)createLayerWayTwo:(float)duration{
    
    
    __block YLCircleView *circleView = [[YLCircleView alloc]initWithFrame:self.bounds lineWidth:self.lineWidth lindeColor:self.lineColor size:0.5];
    [self.backGroundView addSubview:circleView];
    [UIView animateWithDuration:duration delay:0 options:(UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction) animations:^{
        circleView.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
        circleView.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [circleView removeFromSuperview];
    }];
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval: 0.3 target:self selector:@selector(startARCTopAnimation) userInfo:nil  repeats: YES];
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (UILabel *)statusLabel {
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] initWithFrame: CGRectMake(self.width*0.15, self.height*0.1, self.width*0.7, self.height*0.3)];
        [self addSubview: _statusLabel];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.font = [UIFont systemFontOfSize: 14];
        _statusLabel.text = @"还没声音";
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}


- (void)creatBackGroundView:(CGRect)frame {
    if (self.backGroundView == nil) {
        self.backGroundView = [[UIView alloc]initWithFrame:frame];
        self.backGroundView.clipsToBounds = false;
        self.backGroundView.backgroundColor = [UIColor clearColor];
        [self.window addSubview: self.backGroundView];
        self.backGroundView.center = self.window.center;
        
    }
}

@end






















