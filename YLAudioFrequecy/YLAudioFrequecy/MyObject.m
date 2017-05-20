//
//  MyObject.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2017/5/19.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "MyObject.h"

static NSMutableDictionary *map = nil;

@implementation MyObject
+ (void)load
{
    map = [NSMutableDictionary dictionary];
    
    map[@"name1"]                = @"name";
    map[@"status1"]              = @"status";
    map[@"name2"]                = @"name";
    map[@"status2"]              = @"status";
}


@end
