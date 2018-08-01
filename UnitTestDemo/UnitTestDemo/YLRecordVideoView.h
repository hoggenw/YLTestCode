//
//  YLRecordVideoView.h
//  UnitTestDemo
//
//  Created by 王留根 on 2018/7/30.
//  Copyright © 2018年 王留根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoPreDefine.h"

@interface YLRecordVideoView : UIView

@property (nonatomic, assign) YLVideoQuality  videoQuality;
@property (nonatomic, weak)id<YLRecordVideoChoiceDelegate> delegate;
@property (nonatomic, copy) NSString *customVideoPath;

-(void)startRecord;
-(void)stopRecord ;
-(void)restartRecord;
-(void)previewCaptureVideo;
-(void)choiceVideoDelegate;
-(void)preparePreview;

@end
