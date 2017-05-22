//
//  TestRuntime.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2017/5/19.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "TestRuntime.h"

@interface TestRuntime() {
    NSInteger _instance1;
    NSString * _instance2;
}
@property (nonatomic,assign) NSUInteger integer;

-(void) method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2;

@end


@implementation TestRuntime

+ (TestRuntime *)shareRuntimer{
    static TestRuntime *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[self alloc] init];
    });
    return share;
}

+(void)classMethod1 {
    
}

-(void)method1{
    NSLog(@"call method method1");
}

-(void)method2 {
    
}

-(void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2 {
    NSLog(@"arg1 : %ld, arg2 : %@", arg1, arg2);
}

@end






























