//
//  YLVoiceCircleView.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/2/5.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLVoiceCircleView : UIView

@property(nonatomic,strong)UIView * backGroundView;
//开始动画
- (void)startAnimation;
- (void)stopArcAnimation;

@end