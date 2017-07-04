//
//  AppDelegate.h
//  ftxmall
//
//  Created by wanthings mac on 15/12/17.
//  Copyright © 2015年 wanthings. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *Url;//服务器地址
@property (copy, nonatomic) NSString *webUrl;//广告地址
@property (assign, nonatomic) BOOL isUpdate;//是否有更新



@end

