//
//  YLRecordControlView.h
//  UnitTestDemo
//
//  Created by 王留根 on 2018/7/30.
//  Copyright © 2018年 王留根. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordHeader.h"
#import "YLProgressRecordView.h"

@interface YLRecordControlView : UIView

@property (nonatomic, assign)Float64 totalSeconds;
@property (nonatomic, weak)id<YLRecordVideoControlDelegate> delegate;
@property (nonatomic, strong)YLProgressRecordView *progressView;
@property (nonatomic, assign) BOOL ifRestart;




@end
