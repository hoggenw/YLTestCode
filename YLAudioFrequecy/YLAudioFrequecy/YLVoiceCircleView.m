//
//  YLVoiceCircleView.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/2/5.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLVoiceCircleView.h"
#import "ExtensionHeader.h"


@interface YLVoiceCircleView ()

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

@implementation YLVoiceCircleView



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
        self.lineColor = [UIColor greenColor];
        self.colidColor = self.lineColor;
        self.count = 0;
        self.layer.cornerRadius = self.width/2;
        self.clipsToBounds = true;
        self.backgroundColor = [[UIColor brownColor] colorWithAlphaComponent:0.8];
        [window addSubview: self];
        self.center = window.center;

        
    }
    return self;
}

@end
