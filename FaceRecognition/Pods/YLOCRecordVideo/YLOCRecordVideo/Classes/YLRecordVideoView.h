//
//  YLRecordVideoView.h
//  UnitTestDemo
//
//  Created by 王留根 on 2018/7/30.
//  Copyright © 2018年 王留根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordHeader.h"

@interface YLRecordVideoView : UIView

@property (nonatomic, assign) YLVideoQuality  videoQuality;
@property (nonatomic, weak)id<YLRecordVideoControlDelegate> delegate;
@property (nonatomic, copy) NSString *customVideoPath;
@property (nonatomic, assign) CGFloat totalSeconds;

-(void)startRecord;
-(void)stopRecord ;
-(void)restartRecord;
-(void)previewCaptureVideo;
-(void)choiceVideoDelegate;
-(void)preparePreview;

@end
