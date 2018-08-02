//
//  YLRecordVideoManager.m
//  UnitTestDemo
//
//  Created by 王留根 on 2018/8/2.
//  Copyright © 2018年 王留根. All rights reserved.
//

#import "YLRecordVideoManager.h"
#import "YLRecordVideoView.h"


@interface YLRecordVideoManager ()

@end


@implementation YLRecordVideoManager
-(instancetype)init {
    self = [super init];
    if (self) {
        _videoQuality = NormalQuality;
    }
    return self;
}
//非单例
+(YLRecordVideoManager *)shareManager{
    return [[YLRecordVideoManager alloc] init];
}



@end
