//
//  YLRecordVideoManager.h
//  UnitTestDemo
//
//  Created by 王留根 on 2018/8/2.
//  Copyright © 2018年 王留根. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DemoPreDefine.h"

@interface YLRecordVideoManager : NSObject

@property (nonatomic, assign) YLVideoQuality videoQuality;
@property (nonatomic, assign) Float64 recordTotalTime;
@property (nonatomic, weak) id<YLRecordVideoChoiceDelegate>  delegate;

@end
