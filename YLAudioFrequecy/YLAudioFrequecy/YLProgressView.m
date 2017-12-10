//
//  YLProgressView.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2017/11/30.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "YLProgressView.h"


@interface YLProgressView()

@property (nonatomic, strong) CAShapeLayer * shapeLayer;

@property (nonatomic, assign) NSTimeInterval incInterval;

@property (nonatomic, assign) NSTimeInterval totalTimerInterval;

@property (nonatomic, assign) NSTimeInterval totalTime;

@property (nonatomic, assign) CGFloat showProgress;

@property (nonatomic, assign) CGFloat startProgress;


@end

@implementation YLProgressView


-(void)dealloc {
    if (_progressTimer != nil) {
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
    
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _incInterval = 0.05;
        self.shapeLayer = [CAShapeLayer layer];
        _shapeLayer.borderWidth = 1;
        _shapeLayer.lineWidth = 4;
        _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        [self.layer addSublayer: _shapeLayer];
    }
    return self;
}

- (void)startProgress:(CGFloat) progress totalTime:(NSTimeInterval) totalTime {
    _showProgress = progress;
    _startProgress = progress;
    _totalTimerInterval = totalTime;
    _totalTime = totalTime;
    _progressTimer = [NSTimer timerWithTimeInterval:_incInterval target: self selector: @selector(timerProgress) userInfo: nil repeats: true];
    [[NSRunLoop currentRunLoop] addTimer: _progressTimer forMode:NSDefaultRunLoopMode];
}

-(void)timerProgress {
    
}

@end
