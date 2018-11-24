//
//  YLScanLineAnimation.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/11/20.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLScanLineAnimation.h"


@interface YLScanLineAnimation ()

@property (nonatomic, assign) BOOL isAnimationing;
@property (nonatomic, assign) BOOL ifNetGrid;
@property (nonatomic, assign) CGRect animationRect;

@end

@implementation YLScanLineAnimation

-(void)dealloc{
    [self stopStepAnimation];
}

-(instancetype)init {
    @throw [NSException exceptionWithName:@"单例类" reason:@"不能用此方法构造" userInfo:nil];
}

-(instancetype)initPrivate {
    if (self = [super init]) {
        self.isAnimationing = false;
        self.ifNetGrid = false;
        self.animationRect = CGRectZero;
    }
    return  self;
}
+(instancetype)sharedInstance {
    static YLScanLineAnimation * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[self alloc] initPrivate];
        }
    });
    return  manager;
}

+(instancetype)nerGridInstance {
    static YLScanLineAnimation * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[self alloc] initPrivate];
            manager.ifNetGrid = true;
        }
    });
    return  manager;
}

-(void)startAnimationingWithRect:(CGRect)animationRect parentView:(UIView *)parentView  image:(UIImage *)image{
    self.image = image;
    self.animationRect = animationRect;
    [parentView addSubview: self];
    [self setHidden: false];
    _isAnimationing = true;
    if (image != nil) {
        [self stepAnimation];
    }
    
}

-(void)stepAnimation {
    if (!_isAnimationing) {
        return;
    }
    CGRect frame = _animationRect;
    CGFloat imageH = self.image.size.height * _animationRect.size.width / self.image.size.width;
    frame.origin.y = frame.origin.y - imageH;
    frame.size.height = imageH;
    self.frame = frame;
    self.alpha = 0.0;
    NSTimeInterval timeInterval = 1.4;
    if (_ifNetGrid) {
        timeInterval = 1.2;
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:timeInterval animations:^{
        weakSelf.alpha = 1.0;
        CGRect frame = _animationRect;
        CGFloat imageH = weakSelf.image.size.height * _animationRect.size.width / weakSelf.image.size.width;
        frame.origin.y = frame.origin.y  + frame.size.height - imageH;
        frame.size.height = imageH;
        weakSelf.frame = frame;
    } completion:^(BOOL finished) {
        [weakSelf performSelector:(@selector(stepAnimation)) withObject:nil afterDelay:0.3];
    }];
    
    
}

-(void)stopStepAnimation {
    [self setHidden: true];
    self.isAnimationing = false;
}

@end

