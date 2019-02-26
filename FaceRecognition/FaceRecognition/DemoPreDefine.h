//
//  DemoPreDefine.h
//  IFlyFaceRequestDemo
//
//  Created by 付正 on 16/3/1.
//  Copyright (c) 2016年 fuzheng. All rights reserved.
//

#ifndef IFlyFaceRequestDemo_DemoPreDefine_h
#define IFlyFaceRequestDemo_DemoPreDefine_h


#define Margin  5
#define Padding 10
#define iOS9TopMargin 64 //导航栏44，状态栏20
#define IOS9_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )
#define ButtonHeight 44
#define NavigationBarHeight 44
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define VIDEO_FOLDER @"videoFolder" //视频录制存放文件夹

//video
#define RECORD_MAX_TIME 10.0           //最长录制时间
#define TIMER_INTERVAL 0.05         //计时器刷新频率

#define RECORDFILRSTRINGNAME           @"RECORDFILRSTRINGNAMEISNOTCHAGEDFOEEVER"
//typedef enum : NSInteger {
//    Success = 1,
//    UnAuthorized,
//    Failed
//}AVCameraStatues;
//
//typedef enum : NSInteger {
//    NormalQuality,
//    LowQuality,
//    HighQuality
//}YLVideoQuality;

/// 人脸朝向类型
typedef NS_ENUM(NSUInteger,YLFaceDirectionType) {
    YLFaceDirectionTypeUp   = 0,           ///< 人脸向上，即人脸朝向正常
    YLFaceDirectionTypeLeft = 1,           ///< 人脸向左，即人脸被逆时针旋转了90度
    YLFaceDirectionTypeDown = 2,           ///< 人脸向下，即人脸被旋转了180度
    YLFaceDirectionTypeRight= 3            ///< 人脸向右，即人脸被顺时针旋转了90度
};

@protocol YLRecordVideoChoiceDelegate <NSObject>
-(void)choiceVideoWith:(NSString *)path;
@end

@protocol YLRecordVideoControlDelegate <NSObject>
-(void)startRecordDelegate;
-(void)restartRecordDelegate;
-(void)cancelRecordDelegate;
-(void)stopRecordDelegate;
-(void)choiceVideoDelegate;
@end


#ifdef __IPHONE_6_0
# define IFLY_ALIGN_CENTER NSTextAlignmentCenter
#else
# define IFLY_ALIGN_CENTER UITextAlignmentCenter
#endif

#ifdef __IPHONE_6_0
# define IFLY_ALIGN_LEFT NSTextAlignmentLeft
#else
# define IFLY_ALIGN_LEFT UITextAlignmentLeft
#endif


#endif