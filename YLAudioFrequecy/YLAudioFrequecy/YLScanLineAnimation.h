//
//  YLScanLineAnimation.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/11/20.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YLScanLineAnimation : UIImageView

+(instancetype)sharedInstance ;
+(instancetype)nerGridInstance;

-(void)stopStepAnimation;
-(void)startAnimationingWithRect:(CGRect)animationRect parentView:(UIView *)parentView  image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
