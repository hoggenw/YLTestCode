//
//  YLOCScan.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/11/20.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#ifndef YLOCScan_h
#define YLOCScan_h

#import "YLScanResult.h"




typedef NS_ENUM(NSUInteger, YLScanViewAnimationStyle) {
    LineMove, //线条上下移动
    NetGrid ,//网格
    LineStill, //线条停止在扫码区域中央
    None, //无动画
};

typedef NS_ENUM(NSUInteger, YLScanViewPhotoframeAngleStyle) {
    Inner,//内嵌，一般不显示矩形框情况下
    Outer,//外嵌,包围在矩形框的4个角
    On  , //在矩形框的4个角上，覆盖
};
typedef enum : NSUInteger {
    firstLine,
    secondeLine,
    firstNetGrid,
    secondeNetGrid,
} YLAnimationImageStyle;

@protocol YLScanViewControllerDelegate <NSObject>
-(void)scanViewControllerSuccessWith:(YLScanResult *)result;

@end


#define red_notRecoginitonArea 0.0// MARK: -非识别区域颜色,默认 RGBA (0,0,0,0.5)，范围（0--1）
#define green_notRecoginitonArea 0.0
#define blue_notRecoginitonArea 0.0
#define alpa_notRecoginitonArea 0.5

#endif /* YLOCScan_h */



