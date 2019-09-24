//
//  YLScanViewController.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/11/20.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLOCScan.h"

@class YLScanViewSytle;
@class YLScanView;

NS_ASSUME_NONNULL_BEGIN

@interface YLScanViewController : UIViewController

@property (nonatomic,strong)YLScanViewSytle * scanStyle;
@property (nonatomic,strong)YLScanView * qRScanView;
//启动区域识别功能
@property (nonatomic,assign) BOOL isOpenInterestRect ;

//闪光灯
@property (nonatomic,strong)UIButton * btnFlash;

//返回
@property (nonatomic,strong)UIButton * buttonBcak;

//相册
@property (nonatomic,strong)UIButton * buttonPhone;

//识别码的类型
@property (nonatomic,strong)NSArray<NSString*> * arrayCodeType;

//是否需要识别后的当前图像
@property (nonatomic,assign) BOOL  isNeedCodeImage;

//
@property (nonatomic,assign) BOOL  ifShow;

@property (nonatomic,weak)id<YLScanViewControllerDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
