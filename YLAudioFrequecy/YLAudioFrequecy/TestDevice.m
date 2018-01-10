//
//  TestDevice.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/1/10.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "TestDevice.h"
#import <sys/utsname.h>

@implementation TestDevice

- (void)logDeviceInformation {
    NSString * deviceName =  [[UIDevice currentDevice] systemName];
    NSString * systemVersion =  [[UIDevice currentDevice] systemVersion];
    NSString * localizedModel =  [[UIDevice currentDevice] localizedModel];
    NSString * model =  [[UIDevice currentDevice] model];
    NSString * name =  [[UIDevice currentDevice] name];
}


@end
