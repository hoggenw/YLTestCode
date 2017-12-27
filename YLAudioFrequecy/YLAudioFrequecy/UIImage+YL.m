//
//  UIImage+YL.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2017/12/26.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "UIImage+YL.h"
#import <objc/runtime.h>

@implementation UIImage (YL)

+(UIImage *)YLImageNamed:(NSString *)name {
    NSLog(@"拦截系统的imageNamed方法");
    return [UIImage YLImageNamed: name];
}

+(void)load {
    // 获取两个类的类方法
    Method m1 = class_getClassMethod([UIImage class], @selector(imageNamed:));
    Method m2 = class_getClassMethod([UIImage class], @selector(YLImageNamed:));
    // 开始交换方法实现
    method_exchangeImplementations(m1, m2);
}

@end
