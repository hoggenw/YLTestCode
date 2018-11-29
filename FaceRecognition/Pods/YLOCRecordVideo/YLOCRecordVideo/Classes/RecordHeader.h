//
//  RecordHeader.h
//  iOSProject
//
//  Created by 王留根 on 2018/11/22.
//  Copyright © 2018年 hoggenWang.com. All rights reserved.
//

#ifndef RecordHeader_h
#define RecordHeader_h

#define Margin  5
#define Padding 10
#define iOS9TopMargin 64 //导航栏44，状态栏20
#define IOS9_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )
#define ButtonHeight 44
#define NavigationBarHeight 44
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define VIDEO_FOLDER @"videoFolder" //视频录制存放文件夹

typedef enum : NSInteger {
    Success = 1,
    UnAuthorized,
    Failed
}AVCameraStatues;

typedef enum : NSInteger {
    NormalQuality,
    LowQuality,
    HighQuality
}YLVideoQuality;




@protocol YLRecordVideoControlDelegate <NSObject>
-(void)startRecordDelegate;
-(void)restartRecordDelegate;
-(void)cancelRecordWith:(NSString *)path;
-(void)stopRecordWith:(NSString *)path;
-(void)choiceVideoWith:(NSString *)path;
@end

#endif /* RecordHeader_h */
