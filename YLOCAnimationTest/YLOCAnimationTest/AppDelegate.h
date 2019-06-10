//
//  AppDelegate.h
//  YLOCAnimationTest
//
//  Created by 王留根 on 2018/2/7.
//  Copyright © 2018年 hoggen. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BMKLocation;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray<BMKLocation *> *locationArray;

@end

