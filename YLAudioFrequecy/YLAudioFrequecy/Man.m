//
//  MyObject.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2017/5/19.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "Man.h"

static NSMutableDictionary *map = nil;


@interface Fish: NSObject

@property (nonatomic, copy) NSString    *   name;
@property (nonatomic, assign) float     weight;
@property (nonatomic, assign) float     height;

@end

@implementation Fish

-(void)setName:(NSString *)name {
    _name = name;
    NSLog(@"fish'name is %@",name);
}

@end

@interface Dog: NSObject

@property (nonatomic, copy) NSString    *   name;
@property (nonatomic, assign) NSInteger      age;
@property (nonatomic, strong) Fish    *   fish;
@property (nonatomic, assign) float      height;

@end

@implementation Dog
-(void)setName:(NSString *)name {
    _name = name;
    NSLog(@"dog'name is %@",name);
}

@end

@interface Book: NSObject

@property (nonatomic, copy) NSString    *   name;
@property (nonatomic, assign) NSString *      pibliser;
@property (nonatomic, assign) NSString *      price;

@end

@implementation Book
-(void)setName:(NSString *)name {
    _name = name;
    NSLog(@"Book'name is %@",name);
}

@end


@implementation Man

+(NSDictionary *)commonJson {
    
    return @{@"name":@"tom",@"age":@(20),@"height":@(181),@"money":@"100.00"};
}

+(NSDictionary *)specialJson {
    return @{@"name":@"tom",@"age":@(20),@"height":@(181),@"money":@"100.00",@"dog":@{
                     @"name":@"green", @"age":@(3), @"fish":@{@"name":@"鱼",@"weight":@(500)}
                     }};
}

+(NSDictionary *)specialArrayJson {
    return @{@"name":@"tom",@"age":@(20),@"height":@(181),@"money":@"100.00",@"dog":@{
                     @"name":@"green", @"age":@(3), @"fish":@{@"name":@"鱼",@"weight":@(500)}
                     },
             @"books":@[@{@"name":@"c语言",@"price":@(30),@"pibliser":@"dsadsad"},@{@"name":@"iOS开发核心手册",@"price":@(30),@"pibliser":@"dsadsad"}]
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"books":[Book class]};
}

@end

