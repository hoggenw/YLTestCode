//
//  YLWKWebView.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2017/11/30.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "YLWKWebView.h"

@interface YLWKWebView()

@property (nonatomic, strong) CAShapeLayer * progressLayer;
@property (nonatomic, strong) UIView * progressView;
@property (nonatomic, assign) float oldValue;


@end


@implementation YLWKWebView

-(void)dealloc {
    [self removeObserver:self forKeyPath: @"estimatedProgress"];
    
}


- (void)initProgressView {
    self.progressView = [UIView new];
    self.oldValue = 0;
    self.progressLayer = [[CAShapeLayer alloc] initWithLayer: self.progressView.layer];
    self.progressView.frame = CGRectMake(0, 64, self.bounds.size.width, 4);
    self.progressView.backgroundColor = [UIColor clearColor];
    
    [self addSubview: self.progressView];
    _progressLayer.borderWidth = 1;
    _progressLayer.lineWidth = 4;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];
    [self tintColorDidChange];
    [self.progressView.layer addSublayer: self.progressLayer];
    
}

-(void)tintColorDidChange {
    if ([self.superclass instancesRespondToSelector:@selector(tintColorDidChange)]) {
        [super tintColorDidChange];
    }
    _progressLayer.strokeColor = self.progressCorlor.CGColor;
    _progressLayer.borderColor = self.progressCorlor.CGColor;
    
}

-(WKNavigation *)loadRequest:(NSURLRequest *)request {
    [self initProgressView];
    [self addObserver: self forKeyPath: @"estimatedProgress" options: NSKeyValueObservingOptionNew context:nil];
    return  [super loadRequest: request];
}

- (void)update:(CGFloat) progress {
    [CATransaction begin];
    [CATransaction setValue: kCFBooleanTrue forKey: kCATransactionDisableActions];
    self.progressLayer.strokeEnd = progress;
    self.progressLayer.strokeStart = 0;
    [CATransaction commit];
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.progressLayer.path = [self shapeLayerPath].CGPath;
}


- (UIBezierPath *)shapeLayerPath {
    CGFloat width = self.frame.size.width;
    CGFloat borderWidth = self.progressLayer.borderWidth;
    UIBezierPath * path = [UIBezierPath new];
    path.lineWidth = borderWidth;
    path.lineJoinStyle = kCGLineJoinRound;
    [path moveToPoint: CGPointMake(0, 0)];
    [path addLineToPoint: CGPointMake(width, 0)];
    return  path;
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (keyPath != nil && change != nil) {
        if ([keyPath isEqualToString: @"estimatedProgress"]) {
            self.progressLayer.opacity = 1;
            NSNumber *newValue = change[NSKeyValueChangeNewKey];
            if (newValue.floatValue < self.oldValue) {
                return;
            }
            self.oldValue = newValue.floatValue;
            [self update: newValue.floatValue];
            if (newValue.intValue == 1) {
                self.oldValue = 0;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self update: 0];
                });
            }
            
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}



@end
