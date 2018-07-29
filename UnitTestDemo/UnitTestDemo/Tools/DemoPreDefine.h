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


#define USER_APPID           @"5b5a8028"
typedef enum : NSInteger {
    Success,
    UnAuthorized,
    Failed
}AVCameraStatues;

typedef enum : NSInteger {
    NormalQuality,
    LowQuality,
    HighQuality
}YLVideoQuality;

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
