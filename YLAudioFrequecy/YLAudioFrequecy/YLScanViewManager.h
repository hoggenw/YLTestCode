//
//  YLScanViewManager.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/11/21.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLOCScan.h"
#import "YLScanViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLScanViewManager : NSObject

@property (nonatomic,weak)id<YLScanViewControllerDelegate> delegate;
 //是否需要扫描框
@property (nonatomic,assign)BOOL isNeedShowRetangle;
/**
 * 矩形框线条颜色，默认白色
 */
@property (nonatomic,strong)UIColor * colorRetangleLine;

/**
 *  默认扫码区域为正方形，如果扫码区域不是正方形，设置宽高比
 */
@property (nonatomic,assign)float whRatio;

/**
 *  矩形框(视频显示透明区)域向上移动偏移量，0表示扫码透明区域在当前视图中心位置，如果负值表示扫码区域下移(默认44)
 */
@property (nonatomic,assign)float centerUpOffset;

/**
 *  矩形框宽度
 */
@property (nonatomic,assign)float scanViewWidth;


/**
 *  扫码区域的4个角类型
 */
@property (nonatomic,assign)YLScanViewPhotoframeAngleStyle photoframeAngleStyle;

//4个角的颜色
@property (nonatomic,strong)UIColor * colorAngle;


/**
 扫码区域4个角的线条宽度,默认6，建议8到4之间
 */
@property (nonatomic,assign)float photoframeLineW;

/**
 *  自带扫描动画image样式
 */
@property (nonatomic,assign)YLAnimationImageStyle imageStyle;

/**
 *  动画效果的图像，自定义图像
 */
@property (nonatomic,strong)UIImage * animationImage;

+(instancetype)sharedInstance;
//显示扫描界面
-(void)showScanView:(UIViewController *)viewController ;

//生成二维码界面
/*
 frame: 生成视图的frame
 logoIconName：是否需要logo。可选
 codeMessage： 二维码包含信息
 **/
-(UIView *)produceQRcodeView:(CGRect)frame logoIconName:(NSString *)logoIconName codeMessage:(NSString *)codeMessage;

@end

NS_ASSUME_NONNULL_END
