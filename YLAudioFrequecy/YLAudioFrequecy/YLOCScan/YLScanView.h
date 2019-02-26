//
//  YLScanView.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/11/20.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLScanViewSytle.h"
#import "YLScanLineAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLScanView : UIView
//扫描区域
@property(nonatomic, assign)CGRect scanRetangleRect;
//扫描线
@property(nonatomic, strong)YLScanLineAnimation *scanLineAnimation;
//网格扫描线
@property(nonatomic, strong)YLScanLineAnimation *scanNetAnimation;
//线条在中间位置，不移动
@property(nonatomic, strong)UIImageView * fixedLine;
//启动相机时的等待
@property(nonatomic, strong)UIActivityIndicatorView * activityView;
//启动相机时的等待文字
@property(nonatomic, strong)UILabel * labelReadying;
//动画运行状态
@property(nonatomic, assign)BOOL isAnimationing;
//默认设置
@property(nonatomic, strong)YLScanViewSytle *viewStyle;


-(instancetype)initWithFrame:(CGRect)frame scanViewStyle:(YLScanViewSytle *)viewStyle;

-(void)startScanAnimation;

-(void)deviceStartReadying:(NSString *) readyStr;

-(void)stopScanAnimtion ;

-(void)deviceStopReadying;

+(CGRect)getScanRectWithPreview:(UIView *)preview style:(YLScanViewSytle *)style ;
@end

NS_ASSUME_NONNULL_END
