//
//  YLRecordVideoManager.m
//  UnitTestDemo
//
//  Created by 王留根 on 2018/8/2.
//  Copyright © 2018年 王留根. All rights reserved.
//

#import "YLRecordVideoManager.h"



@interface YLRecordVideoManager ()

@property (nonatomic, strong)YLRecordVideoView * recordView;

@end


@implementation YLRecordVideoManager
-(instancetype)init {
    self = [super init];
    if (self) {
        _videoQuality = NormalQuality;
        _recordTotalTime = 10;
    }
    return self;
}
//非单例
+(YLRecordVideoManager *)shareManager{
    return [[YLRecordVideoManager alloc] init];
}

-(void)setVideoQuality:(YLVideoQuality)videoQuality {
    _videoQuality = videoQuality;
    self.recordView.videoQuality = videoQuality;
    
}

-(void)setRecordTotalTime:(Float64)recordTotalTime {
    _recordTotalTime = recordTotalTime;
    self.recordView.totalSeconds = recordTotalTime;
}

-(YLRecordVideoView *)showRecordView:(CGRect)frame{
    self.recordView = [[YLRecordVideoView alloc]initWithFrame:frame];
    return  self.recordView;
}




@end
