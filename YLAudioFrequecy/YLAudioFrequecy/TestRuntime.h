//
//  TestRuntime.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2017/5/19.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestRuntime : NSObject <NSCopying,NSCoding>

@property (nonatomic,strong) NSArray *array;

@property (nonatomic, copy) NSString *string;

+ (TestRuntime *)shareRuntimer;

-(void)method1;

-(void)method2;

+(void)classMethod1;
+(void)classMethod2;

@end

