//
//  NSObject+JSONExtension.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2017/12/26.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "NSObject+JSONExtension.h"
#import <objc/runtime.h>

@implementation NSObject (JSONExtension)

- (void)setDict:(NSDictionary *)dict {
    Class clazz = self.class;
    while (clazz && clazz != [NSObject class]) {
        unsigned int outCount = 0;
        Ivar * ivars = class_copyIvarList(clazz, &outCount);
        for (unsigned int i  = 0; i < outCount; i ++) {
            Ivar ivar = ivars[i];
            NSString * key = [NSString stringWithUTF8String: ivar_getName(ivar)];
            // 成员变量名转为属性名（去掉下划线 _ ）
            key = [key substringFromIndex:1];
            id value = dict[key];
            // 如果模型属性数量大于字典键值对数理，模型属性会被赋值为nil而报错
            if (value == nil) {
                continue;
            }
            NSString * type = [NSString stringWithUTF8String: ivar_getTypeEncoding(ivar)];
            
            NSRange range = [type rangeOfString:@"@"];
            if (range.location != NSNotFound) {
                type = [type substringWithRange:NSMakeRange(2, type.length - 3)];
                NSLog(@"type = %@",type);
                if (![type hasPrefix:@"NS"]) {
                    Class class = NSClassFromString(type);
                    value = [class objectWithDict: value];
                }else if ([type isEqualToString:@"NSArray"]){
                   // NSLog(@"array");
                    NSArray * vauleArray = (NSArray *)value;
                    NSMutableArray * mArray = [NSMutableArray array];
                    
                    // 获取到每个模型的类型
                    id class ;
                    if ([[self class] respondsToSelector:@selector(modelContainerPropertyGenericClass)]) {
                        
                        class =  [[self class]  modelContainerPropertyGenericClass] [key];
                        NSLog(@"class: %@",NSStringFromClass(class));
                    }else {
                        
                        NSLog(@"数组内模型是未知类型");
                        return;
                    }
                    for (int i = 0; i < vauleArray.count; i++) {
                        [mArray addObject:[class objectWithDict:value[i]]];
                    }
                }
            }
            [self setValue: value forKey: key];
            
            
            
        }
        free(ivars);
        clazz = [clazz superclass];
        
    }
}

+(instancetype)objectWithDict:(NSDictionary *)dict {
    NSObject *obj = [[self alloc]init];
    [obj setDict:dict];
    return obj;
}

@end
