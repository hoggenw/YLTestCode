//
//  NSObject+JSONExtension.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2017/12/26.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSONExtension)
+(instancetype)objectWithDict:(NSDictionary *)dict;
//// 告诉数组中都是什么类型的模型对象
+ (NSDictionary *)modelContainerPropertyGenericClass;
@end
