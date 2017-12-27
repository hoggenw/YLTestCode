//
//  MyObject.h
//  YLAudioFrequecy
//
//  Created by 王留根 on 2017/5/19.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Dog;
@class Book;
@interface Man: NSObject

@property (nonatomic, copy) NSString    *   name;
@property (nonatomic, copy) NSString    *   money;
@property (nonatomic, assign) NSInteger       age;
@property (nonatomic, assign) float      height;
@property (nonatomic, strong) Dog    *   dog;
@property (nonatomic, strong) NSArray<Book *>    *   books;


+(NSDictionary *)commonJson;

+(NSDictionary *)specialJson;

+(NSDictionary *)specialArrayJson ;
@end
