//
//  TestRunLoop.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/1/4.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestRunLoop : NSObject
@property (nonatomic,strong)   NSThread * thread;
-(void)logStatusOfRunLoop;
-(void)showRunLoop;
@end
