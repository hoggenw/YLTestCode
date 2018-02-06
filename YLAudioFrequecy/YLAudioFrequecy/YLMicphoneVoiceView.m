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
@property(nonatomic,assign)NSInteger count;
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
        self.lineColor = [UIColor whiteColor];
        self.colidColor = self.lineColor;
        self.count = 0;
        self.layer.cornerRadius = self.width/2;
        self.clipsToBounds = true;
        self.backgroundColor = [[UIColor brownColor] colorWithAlphaComponent:0.8];
        [window addSubview: self];
        self.center = window.center;
         [self addMicrophoneView];
        
    }
    return self;
}

- (void)addMicrophoneView {
    self.microphoneView = [[MicrophoneView alloc] initColorAndLineWidthWithRect: CGRectMake(self.width*0.15, self.height*0.3, self.width*0.7, self.height*0.7) voiceColor: [UIColor cyanColor] volumeColor: self.colidColor isColid: false lineWidth: self.lineWidth];
    [self addSubview: self.microphoneView];
}


//开始动画
- (void)startAnimation {
    [self.timer resumeTimer];
}

- (void)startARCTopAnimation {
    [self.microphoneView updateVoiceViewWithVolume: self.count];
    self.count++;
    if (self.count > 5) {
        self.count = 0;
    }
    
}

- (void)stopArcAnimation{
    [self.timer pauseTimer];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        self.timer = nil;
    }
    self.count = 0;
    
    
    
}

- (NSTimer *)timer {
    if (_timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval: 0.3 target:self selector:@selector(startARCTopAnimation) userInfo:nil  repeats: YES];
    }
    return _timer;
}

@end
