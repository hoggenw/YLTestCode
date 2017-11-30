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
   //[self creatQueue];
   //[self testCommunication];
    //[self barrier];
     //[self testMain];
    //[self groub];
//    [self deadThread];
  //  [self deadThread2];
}

-(void)groub {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //执行耗时操作1
        NSLog(@"执行耗时操作1");
         NSLog(@"执行耗时操作1------%@",[NSThread currentThread]);
        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"内部在异步1");
            NSLog(@"内部在异步1------%@",[NSThread currentThread]);
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"内部在异步3");
            NSLog(@"内部在异步3------%@",[NSThread currentThread]);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSLog(@"内部在异步2");
                NSLog(@"内部在异步2------%@",[NSThread currentThread]);
                
            });
        });
        
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //执行耗时操作2
        NSLog(@"执行耗时操作2------%@",[NSThread currentThread]);
        NSLog(@"执行耗时操作2");
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //执行耗时操作3
        NSLog(@"执行耗时操作3------%@",[NSThread currentThread]);
        NSLog(@"执行耗时操作3");
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"前面的异步操作已完成");
    });
    
    //dispatch_group_create()可以创建一个完全的线程控制，这这个group中的线程，无论该线程是否新开异步线程，
    //dispatch_group_notify都会在该group线程所有内容执行完成以后,再执行相关内容
    //所谓异步执行就是将当前在异步执行的代码以函数块形式排队放到线程(系统分配的线程，不一定是目前执行的线程)执行的最后
    //由于执行的线程不一致，所以完成先后顺序也不一致
    //
    
    
}

-(void)barrier {
    
    //GCD的快速迭代方法
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    /*! dispatch_apply函数说明
           *
           *  @brief  dispatch_apply函数是dispatch_sync函数和Dispatch Group的关联API
           *         该函数按指定的次数将指定的Block追加到指定的Dispatch Queue中,并等到全部的处理执行结束
           *
           *  @param 6    指定重复次数  指定6次
           *  @param queue 追加对象的Dispatch Queue
           *  @param index 带有参数的Block, index的作用是为了按执行的顺序区分各个Block
           *
          */
    
    dispatch_apply(6, globalQueue, ^(size_t index) {
        NSLog(@"%zd---globalQueue---%@",index, [NSThread currentThread]);
    });
    
    dispatch_queue_t queue = dispatch_queue_create("ssss", DISPATCH_QUEUE_CONCURRENT);
    
    
    
   
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"内部在异步1");
            NSLog(@"内部在异步1------%@",[NSThread currentThread]);
            
        });
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"内部在异步2");
            NSLog(@"内部在异步2------%@",[NSThread currentThread]);
            
        });
        dispatch_async(queue, ^{
            for (int i = 0; i < 2; ++i) {
                NSLog(@"内部queue------%@",[NSThread currentThread]);
            }
        });
    });
    //先执行完栅栏前面的在执行后面的
    dispatch_barrier_sync(queue, ^{
        NSLog(@"----barrier-----%@", [NSThread currentThread]);
    });
    
        /**
         1.栅栏操作时候，只能拦截该线程中第一层异步操作的内容，对第一层中再次异步操作的线程无法拦截，同时属于这个线程的也不行
         */
    
    
    
//    dispatch_async(queue, ^{
//        for (int i = 0; i < 2; ++i) {
//            NSLog(@"3------%@",[NSThread currentThread]);
//        }
//    });
//    dispatch_async(queue, ^{
//        for (int i = 0; i < 2; ++i) {
//            NSLog(@"4------%@",[NSThread currentThread]);
//        }
//    });
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"only once");
    });
    //延时执行，不受栅栏的影响
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"run -----");
    });
}

-(void)testCommunication{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async( dispatch_get_main_queue(), ^{
            
        });
    });
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
    //在指定线程中执行的异步操作，遵循代码执行顺序，碰到异步的函数块，即抛到线程最后排队；
    
}

-(void)creatQueue{
    //串行队列的创建方法
    dispatch_queue_t queueSerial = dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
    //并发队列的创建方法
    dispatch_queue_t queueC = dispatch_queue_create("conTest.queue", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"asyncConcurrent---begin");
    //同步执行任务创建方法
    dispatch_sync(queueC, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1---sync---%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queueC, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2---sync---%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queueC, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3---sync---%@",[NSThread currentThread]);
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
    
    //并发同步队列在一个线程中执行，并发异步队列则由系统分配的线程执行，执行速度不一定比当前线程的速度慢
}

-(void)deadThread {
    NSLog(@"=================4");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"=================5");
    });
    NSLog(@"=================6");
}

-(void)deadThread2 {
    dispatch_queue_t queue = dispatch_queue_create("com.demo.serialQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1"); // 任务1
    dispatch_async(queue, ^{
        NSLog(@"2"); // 任务2
        dispatch_sync(queue, ^{
            NSLog(@"3"); // 任务3
        });
        NSLog(@"4"); // 任务4
    });
    NSLog(@"5"); // 任务5
/**
 执行任务1；
 遇到异步线程，将【任务2、同步线程、任务4】加入串行队列中。因为是异步线程，所以在主线程中的任务5不必等待异步线程中的所有任务完成；
 因为任务5不必等待，所以2和5的输出顺序不能确定；
 任务2执行完以后，遇到同步线程，这时，将任务3加入串行队列；
 又因为任务4比任务3早加入串行队列，所以，任务3要等待任务4完成以后，才能执行。但是任务3所在的同步线程会阻塞，所以任务4必须等任务3执行完以后再执行。这就又陷入了无限的等待中，造成死锁。
 */
}

@end







































