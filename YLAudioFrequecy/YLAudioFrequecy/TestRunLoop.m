//
//  TestRunLoop.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/1/4.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "TestRunLoop.h"

@implementation TestRunLoop

-(void)logStatusOfRunLoop {
    //runloop 状态监听
    // 创建observer
    NSLog(@"即将进入loop kCFRunLoopEntry %zd \n, 即将处理timer kCFRunLoopBeforeTimers %zd \n,即将处理source kCFRunLoopBeforeSources %zd \n, 即将进入休眠 kCFRunLoopBeforeWaiting %zd \n,从休眠中唤醒 kCFRunLoopAfterWaiting %zd \n,即将推出 kCFRunLoopExit %zd \n",kCFRunLoopEntry,kCFRunLoopBeforeTimers,kCFRunLoopBeforeSources,kCFRunLoopBeforeWaiting,kCFRunLoopAfterWaiting,kCFRunLoopExit);
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"----监听到RunLoop状态发生改变---%zd", activity);
    });
    // 添加观察者：监听RunLoop的状态
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    // 释放Observer
    CFRelease(observer);
}

-(void)showRunLoop {
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(show) object:@"xyl"];
    [_thread start];
}

-(void)show {
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addPort:[NSMachPort port] forMode: NSDefaultRunLoopMode];
    [runloop run];
    //NSLog(@"%@",runloop);
    NSLog(@"runrurnrun");
    
/** 未加port 未启动前的runloop
 <CFRunLoop 0x145747a80 [0x1b1dab310]>{wakeup port = 0x6903, stopped = false, ignoreWakeUps = true,
 current mode = (none),
 common modes = <CFBasicHash 0x14458e650 [0x1b1dab310]>{type = mutable set, count = 1,
 entries =>
 2 : <CFString 0x1aa7ac3a8 [0x1b1dab310]>{contents = "kCFRunLoopDefaultMode"}
 }
 ,
 common mode items = (null),
 modes = <CFBasicHash 0x14458e610 [0x1b1dab310]>{type = mutable set, count = 1,
 entries =>
 2 : <CFRunLoopMode 0x145747940 [0x1b1dab310]>{name = kCFRunLoopDefaultMode, port set = 0x6a03, queue = 0x145524490, source = 0x145747800 (not fired), timer port = 0x6c03,
 sources0 = (null),
 sources1 = (null),
 observers = (null),
 timers = (null),
 currently 536727993 (3641813578027) / soft deadline in: 7.68614185e+11 sec (@ -1) / hard deadline in: 7.68614185e+11 sec (@ -1)
 },
 
 }
 }
 */
}
@end
