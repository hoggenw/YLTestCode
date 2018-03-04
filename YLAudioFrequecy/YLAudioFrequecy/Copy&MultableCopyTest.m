//
//  Copy&MultableCopyTest.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2018/3/2.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "Copy&MultableCopyTest.h"

@interface Person : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic, copy) NSMutableString *name;

@end

@implementation Person

- (id)copyWithZone:(NSZone *)zone {
    Person *person = [Person allocWithZone:zone];
    person.name = self.name;
    return person;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    Person *person = [Person allocWithZone:zone];
    person.name = self.name;
    return person;
}

@end

@interface Copy_MultableCopyTest()
@property (nonatomic ,strong) NSArray *array;

@end

@implementation Copy_MultableCopyTest

-(void)propertyTest {
    NSArray *array = @[ @1, @2, @3, @4 ];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:array];
    self.array = [mutableArray copy];//本质上赋值的是mutable的值
    NSLog(@"array :%@, mutableArray: %@,array object_p: %p,object_p: %p",self.array ,mutableArray,self.array ,mutableArray);
    [mutableArray removeAllObjects];
    NSLog(@"array :%@, mutableArray: %@,array object_p: %p,object_p: %p",self.array ,mutableArray,self.array ,mutableArray);
}


- (void)customObjectiveTest {
    
    Person * model = [Person new];
    NSString *nameString = @"hoggen";
    model.name = [nameString mutableCopy];

    Person * copyPerson = [model copy];
    Person * mutableCopyPerson = [model mutableCopy];
    
    NSLog(@"origin_p: %p, class: %@", model, [model class]);
    NSLog(@"copyArray_p: %p, class: %@", copyPerson, [copyPerson class]);
    NSLog(@"mutableCopyArray_p: %p, class: %@", mutableCopyPerson, [mutableCopyPerson class]);
    
    NSLog(@"value:%@, object_p: %p, class: %@",nameString,nameString, [nameString class]);
    NSLog(@"======原对象=====");
    NSLog(@"value:%@, object_p: %p, class: %@",model.name, model.name, [model.name class]);
    
    NSLog(@"======copy对象=====");
    NSLog(@"value:%@, object_p: %p, class: %@",copyPerson.name, copyPerson.name, [copyPerson.name class]);
    
    NSLog(@"======mutableCopy对象=====");
    NSLog(@"value:%@, object_p: %p, class: %@",mutableCopyPerson.name, mutableCopyPerson.name, [mutableCopyPerson.name class]);
    
    NSLog(@"======mutableCopy对象修改值=====");
    mutableCopyPerson.name = [@"wang" mutableCopy];
    //nameString = @"wang";
    //NSLog(@"value:%@, object_p: %p, class: %@",nameString,nameString, [nameString class]);
    
    NSLog(@"======原对象=====");
    NSLog(@"value:%@, object_p: %p, class: %@",model.name, model.name, [model.name class]);
    
    NSLog(@"======copy对象=====");
    NSLog(@"value:%@, object_p: %p, class: %@",copyPerson.name, copyPerson.name, [copyPerson.name class]);
    
    NSLog(@"======mutableCopy对象=====");
    NSLog(@"value:%@, object_p: %p, class: %@",mutableCopyPerson.name, mutableCopyPerson.name, [mutableCopyPerson.name class]);
    
}

- (void)containerTest {
    NSMutableString *multableString = [NSMutableString stringWithFormat:@"非容器可变对象"];
    
    NSArray *array = [NSArray arrayWithObjects:multableString, @"非容器不可变对象", nil];
    NSArray *copyArray = array;//[array copy];
    NSArray *mutableCopyArray = array;// [array mutableCopy];
    
    NSLog(@"array_p: %p, class: %@", array, [array class]);
    NSLog(@"copyArray_p: %p, class: %@", copyArray, [copyArray class]);
    NSLog(@"mutableCopyArray_p: %p, class: %@", mutableCopyArray, [mutableCopyArray class]);
    
    NSLog(@"======原对象=====");
    NSLog(@"value:%@, object_p: %p, class: %@",array[0], array[0], [array[0] class]);
    NSLog(@"value:%@, object_p: %p, class: %@", array[1],array[1], [array[1] class]);
    
    NSLog(@"======copy对象=====");
    NSLog(@"value:%@, object_p: %p, class: %@", copyArray[0],copyArray[0], [copyArray[0] class]);
    NSLog(@"value:%@, object_p: %p, class: %@", copyArray[1],copyArray[1], [copyArray[1] class]);
    
    NSLog(@"======mutableCopy对象=====");
    NSLog(@"value:%@, object_p: %p, class: %@",mutableCopyArray[0], mutableCopyArray[0], [mutableCopyArray[0] class]);
    NSLog(@"value:%@, object_p: %p, class: %@", mutableCopyArray[1],  mutableCopyArray[1], [mutableCopyArray[1] class]);
    
    NSLog(@"======修改原对象的值=====");
    array = nil;
  
    
    NSLog(@"======原对象=====");
    NSLog(@"value:%@, object_p: %p, class: %@",array[0], array[0], [array[0] class]);
    NSLog(@"value:%@, object_p: %p, class: %@", array[1],array[1], [array[1] class]);
    
    NSLog(@"======copy对象=====");
    NSLog(@"value:%@, object_p: %p, class: %@", copyArray[0],copyArray[0], [copyArray[0] class]);
    NSLog(@"value:%@, object_p: %p, class: %@", copyArray[1],copyArray[1], [copyArray[1] class]);
    
    NSLog(@"======mutableCopy对象=====");
    NSLog(@"value:%@, object_p: %p, class: %@",mutableCopyArray[0], mutableCopyArray[0], [mutableCopyArray[0] class]);
    NSLog(@"value:%@, object_p: %p, class: %@", mutableCopyArray[1],  mutableCopyArray[1], [mutableCopyArray[1] class]);
    
    
}


- (void)mutableContainerTest {
    NSMutableString *multableString = [NSMutableString stringWithFormat:@"非容器可变对象"];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:multableString, @"非容器不可变对象", nil];
    NSMutableArray *copyArray = array;//[array copy];
    NSMutableArray *mutableCopyArray = array;//[array mutableCopy];
    
    NSLog(@"array_p: %p, class: %@", array, [array class]);
    NSLog(@"copyArray_p: %p, class: %@", copyArray, [copyArray class]);
    NSLog(@"mutableCopyArray_p: %p, class: %@", mutableCopyArray, [mutableCopyArray class]);
    
    NSLog(@"======原对象=====");
    NSLog(@"object_p: %p, class: %@", array[0], [array[0] class]);
    NSLog(@"object_p: %p, class: %@", array[1], [array[1] class]);
    
    NSLog(@"======copy对象=====");
    NSLog(@"object_p: %p, class: %@", copyArray[0], [copyArray[0] class]);
    NSLog(@"object_p: %p, class: %@", copyArray[1], [copyArray[1] class]);
    
    NSLog(@"======mutableCopy对象=====");
    NSLog(@"object_p: %p, class: %@", mutableCopyArray[0], [mutableCopyArray[0] class]);
    NSLog(@"object_p: %p, class: %@", mutableCopyArray[1], [mutableCopyArray[1] class]);
    
    NSLog(@"======修改原对象的值=====");
    //NSMutableString *mus = ;
    
    array[0] = [NSMutableString stringWithFormat:@"非容器可变对象1"];
    //NSString * str = array[1];
    array[1] = @"非容器不可变对象1";
    //[array removeAllObjects];
    
    NSLog(@"======原对象=====");
    NSLog(@"value:%@, object_p: %p, class: %@",array[0], array[0], [array[0] class]);
    NSLog(@"value:%@, object_p: %p, class: %@", array[1],array[1], [array[1] class]);
    
    NSLog(@"======copy对象=====");
    NSLog(@"value:%@, object_p: %p, class: %@", copyArray[0],copyArray[0], [copyArray[0] class]);
    NSLog(@"value:%@, object_p: %p, class: %@", copyArray[1],copyArray[1], [copyArray[1] class]);
    
    NSLog(@"======mutableCopy对象=====");
    NSLog(@"value:%@, object_p: %p, class: %@",mutableCopyArray[0], mutableCopyArray[0], [mutableCopyArray[0] class]);
    NSLog(@"value:%@, object_p: %p, class: %@", mutableCopyArray[1],  mutableCopyArray[1], [mutableCopyArray[1] class]);
}


@end
