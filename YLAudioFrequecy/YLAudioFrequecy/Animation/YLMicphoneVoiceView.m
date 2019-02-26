//
//  YLMicphoneVoiceView.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/2/5.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLMicphoneVoiceView.h"
#import "ExtensionHeader.h"
#import "MicrophoneView.h"


@interface YLMicphoneVoiceView ()

@property(nonatomic,strong)MicrophoneView * microphoneView;

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

/**
 状态label
 */
@property (nonatomic,strong) UILabel *statusLabel;

@end

@implementation YLMicphoneVoiceView


- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.4;
    frame = CGRectMake(100, 100, width, width);
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CGRect newFrame = frame;
    CGFloat min = (newFrame.size.width >= newFrame.size.height )?newFrame.size.width:newFrame.size.height;
    newFrame.size.width = min;
    newFrame.size.height = min;
    self = [super initWithFrame:newFrame];
    if (self) {
        //        //处理一些默认参数
        //        self.isColid = NO;
        self.lineColor = [UIColor cyanColor];
        self.colidColor = self.lineColor;
        self.count = 0;
        self.layer.cornerRadius = self.width/2;
        self.clipsToBounds = true;
        self.backgroundColor = [[UIColor brownColor] colorWithAlphaComponent:0.8];
        [window addSubview: self];
        self.center = window.center;
        [self initLineWidth];
        [self addMicrophoneView];
        
    }
    return self;
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

    self.microphoneView = [[MicrophoneView alloc] initColorAndLineWidthWithRect: CGRectMake(self.width*0.15, self.height*0.3, self.width*0.7, self.height*0.7) voiceColor: self.lineColor volumeColor: self.colidColor isColid: true lineWidth: self.lineWidth];
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
    [self.microphoneView updateVoiceViewWithVolume: self.count];
    self.count = _count + 0.1;
    if (self.count > 1) {
        self.count = 0;
    }
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

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval: 0.3 target:self selector:@selector(startARCTopAnimation) userInfo:nil  repeats: YES];
    }
    return _timer;
}

- (UILabel *)statusLabel {
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] initWithFrame: CGRectMake(self.width*0.15, 0, self.width*0.7, self.height*0.3)];
        [self addSubview: _statusLabel];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.font = [UIFont systemFontOfSize: 14];
        _statusLabel.text = @"还没声音";
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}

@end
