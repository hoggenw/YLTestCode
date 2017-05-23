//
//  TestGCD.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2017/5/22.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "TestGCD.h"

@implementation TestGCD

-(void)test {
   // [self creatQueue];
   //[self testCommunication];
   // [self barrier];
    [self testMain];
}

-(void)groub {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //执行耗时操作1
        NSLog(@"执行耗时操作1");
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //执行耗时操作2
        NSLog(@"执行耗时操作2");
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"前面的异步操作已完成");
    });
}

-(void)barrier {
    
    //GCD的快速迭代方法
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(6, globalQueue, ^(size_t index) {
        NSLog(@"%zd---globalQueue---%@",index, [NSThread currentThread]);
    });
    
    dispatch_queue_t queue = dispatch_queue_create("ssss", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"run -----");
    });
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"only once");
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    //先执行完栅栏前面的在执行后面的
    dispatch_barrier_sync(queue, ^{
        NSLog(@"----barrier-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"4------%@",[NSThread currentThread]);
        }
    });
    
}

-(void)testCommunication{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (int i = 0; i < 2; ++i) {
                NSLog(@"1------%@",[NSThread currentThread]);
            }
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                for (int i = 0; i < 2; ++i) {
                    NSLog(@"2------%@",[NSThread currentThread]);
                }
            });
        });
}

-(void)testMain{
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"asyncMain---begin");
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_block_t block = ^{
        NSLog(@"block------%@",[NSThread currentThread]);
        NSLog(@"new block message");
    };
    dispatch_async(queue, block);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    NSLog(@"asyncMain---end");
}

-(void)creatQueue{
    //串行队列的创建方案
    dispatch_queue_t queueSerial = dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
    //并发队列的创建方法
    dispatch_queue_t queueC = dispatch_queue_create("conTest.queue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"asyncConcurrent---begin");
    //同步执行任务创建方法
    dispatch_sync(queueC, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queueC, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queueC, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    //异步执行任务创建方法
    dispatch_async(queueC, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queueC, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queueC, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    NSLog(@"syncConcurrent---end");
}

@end







































