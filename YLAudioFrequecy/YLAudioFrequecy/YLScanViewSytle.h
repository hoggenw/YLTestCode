//
//  YLScanViewSytle.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/11/20.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YLOCScan.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLScanViewSytle : NSObject

/// 是否需要绘制扫码矩形框，默认YES
@property (nonatomic, assign)BOOL isNeedShowRetangle;


/**
 *  默认扫码区域为正方形，如果扫码区域不是正方形，设置宽高比
 */
@property (nonatomic, assign)double whRatio;
/**
 @brief  矩形框(视频显示透明区)域向上移动偏移量，0表示扫码透明区域在当前视图中心位置，如果负值表示扫码区域下移
 */
@property (nonatomic, assign)double centerUpOffset;
/**
 *  矩形框(视频显示透明区)域离界面左边及右边距离，默认60
 */
@property (nonatomic, assign)double xScanRetangleOffset;
/**
 @brief  矩形框线条颜色，默认白色
 */
@property (nonatomic, strong)UIColor * colorRetangleLine ;

//MARK -矩形框(扫码区域)周围4个角

/**
 @brief  扫码区域的4个角类型
 */
@property (nonatomic, assign)YLScanViewPhotoframeAngleStyle photoframeAngleStyle;
//4个角的颜色
@property (nonatomic, strong)UIColor * colorAngle;

//扫码区域4个角的宽度和高度
@property (nonatomic, assign)double photoframeAngleW;
@property (nonatomic, assign)double photoframeAngleH;
/**
 @brief  扫码区域4个角的线条宽度,默认6，建议8到4之间
 */
@property (nonatomic, assign)double photoframeLineW;
//MARK:--动画效果
@property (nonatomic, assign)YLScanViewAnimationStyle animationStyle;
/**
 *  动画效果的图像，如线条或网格的图像
 */
@property (nonatomic, strong)UIImage * animationImage;



-(instancetype)init;

@end

NS_ASSUME_NONNULL_END
