//
//  YLRecordVideoManager.h
//  UnitTestDemo
//
//  Created by 王留根 on 2018/8/2.
//  Copyright © 2018年 王留根. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordHeader.h"
#import "YLRecordVideoView.h"

@interface YLRecordVideoManager : NSObject

@property (nonatomic, assign) YLVideoQuality videoQuality;
/**最多可以录60秒，设定可在代码中修改*/
@property (nonatomic, assign) Float64 recordTotalTime;

-(YLRecordVideoView *)showRecordView:(CGRect)frame;
+(YLRecordVideoManager *)shareManager;
@end
