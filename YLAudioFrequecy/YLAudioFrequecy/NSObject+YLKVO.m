//
//  NSObject+YLKVO.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 2017/12/21.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "NSObject+YLKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString * const YLKVOAssociateObservers = @"YLKVOAssociateObservers";
NSString * const YLKVOClassPrefix = @"YL_";

@interface YLObservationInfo: NSObject
@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) YLKVOBlock block;
@end

@implementation YLObservationInfo

- (instancetype)initWithObserver:(NSObject *)observer key:(NSString *)key block:(YLKVOBlock)block {
    self = [super init];
    if (self) {
        _observer = observer;
        _key = key;
        _block = block;
    }
    return  self;
}
@end

static NSString * getterForSetter(NSString * setter) {
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString * key = [setter substringWithRange: range];
    NSString * firstChar = [[key substringToIndex: 1] lowercaseString];
    key = [key stringByReplacingCharactersInRange: NSMakeRange(0, 1) withString: firstChar];
    NSLog(@"key:%@",key);
    return key;
}

static NSString * setterMethodGet(NSString * getter) {
    if (getter.length <= 0) {
        return nil;
    }
    
    // upper case the first letter
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [getter substringFromIndex:1];
    
    // add 'set' at the begining and ':' at the end
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingLetters];
    NSLog(@"setter: %@:",setter);
    return setter;
}

static Class kvo_class(id self, SEL _cmd)
{
    //// 获取类的父类
    return class_getSuperclass(object_getClass(self));
}

static void kvo_setter(id self, SEL _cmd, id newValue) {
    
    NSString * setterName = NSStringFromSelector(_cmd);
    
    NSString *getterName = getterForSetter(setterName);
    NSLog(@"setterName :%@ ---getterNmae: %@ ",setterName,getterName);
    if (!getterName) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have setter %@", self, setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    
    id oldValue = [self valueForKey:getterName];
    //其中receiver是指类的实例，super_class则是指该实例的父类。
    struct objc_super superClazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    objc_msgSendSuperCasted(&superClazz,_cmd,newValue);
    NSMutableArray *observers = objc_getAssociatedObject(self, &YLKVOAssociateObservers);
    for(YLObservationInfo *temp in observers) {
        if ([temp.key isEqualToString: getterName]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                temp.block(self, getterName, oldValue, newValue);
            });
        }
    }
    
    
}

@implementation NSObject (YLKVO)

-(void)YLAddObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(YLKVOBlock)block {
    
    NSLog( @"getterForSetter(%@) : %@",key,setterMethodGet(key));
    SEL setterSelector = NSSelectorFromString(setterMethodGet(key));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);//用 class_getInstanceMethod 去获得 setKey: 的实现（Method）
    //NSLog(@"setterMethod = %@", setterMethod);
    if (!setterMethod) {
        NSString * reason = [NSString stringWithFormat:@"Object %@ doesn not have a setter for key %@ ",self,key];
        @throw [NSException exceptionWithName: NSInvalidArgumentException reason: reason userInfo: nil];
    }
    
    Class clazz = object_getClass(self);
   // NSLog(@"object_getClass(%@) : %@", clazz, object_getClass(self));
    NSString * className = NSStringFromClass(clazz);
    //
    if (![className hasPrefix: YLKVOClassPrefix]) {
        clazz = [self makeKvoClassWithOriginalClassName:className];
        NSLog(@"创建新的kvo类");
        //将一个对象设置为别的类类型，
        Class c1 = object_setClass(self, clazz);
        NSLog(@"cl - %@", [c1 class]);
        NSLog(@"self - %@", [self class]);
    }
    //添加我们自己kvo的类的实现方法，如果被观察的类没有实现它的setter方法
    if (![self haseSelector: setterSelector]) {
        const char * types = method_getTypeEncoding(setterMethod);
        class_addMethod(clazz, setterSelector, (IMP)kvo_setter, types);
        NSLog(@"添加我们自己kvo的类的实现方法，如果类没有实现它的setter方法");
    }
    YLObservationInfo *info = [[YLObservationInfo alloc] initWithObserver:observer key:key block:block];
    NSMutableArray *observers = objc_getAssociatedObject(self, &YLKVOAssociateObservers);
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self,&YLKVOAssociateObservers, observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [observers addObject: info];
    
}

-(void)YLRemoveObserver:(NSObject *)observer forKey:(NSString *)key {
     NSMutableArray *observers = objc_getAssociatedObject(self, &YLKVOAssociateObservers);
    YLObservationInfo *infoToremove;
    for(YLObservationInfo * temp in observers) {
        if (temp.observer == observer && [temp.key isEqual: key]) {
            infoToremove = temp;
            break;
        }
    }
    [observers removeObject: infoToremove];
}

- (Class)makeKvoClassWithOriginalClassName:(NSString *)originalClazzName {
    NSString * kvoClassName = [YLKVOClassPrefix stringByAppendingString: originalClazzName];
    Class classNew = NSClassFromString(kvoClassName);
    if (classNew) {
        return  classNew;
    }
    //不存在这个类，那么久新建它
    Class originClazz =  object_getClass(self);
    //    分配空间,创建类(仅在 创建之后,注册之前 能够添加成员变量)
    Class kvoClazz = objc_allocateClassPair(originClazz, kvoClassName.UTF8String, 0);
    //重写了 class 方法。隐藏这个子类的存在。最后 objc_registerClassPair() 告诉 Runtime 这个类的存在。
    Method clazzMethod = class_getInstanceMethod(originClazz, @selector(class));
      //获取方法的Type字符串(包含参数类型和返回值类型)
    const char * types = method_getTypeEncoding(clazzMethod);
    /**
     kvoClazz 参数表示需要添加新方法的类。
      @selector(class) 参数表示 selector 的方法名称，可以根据喜好自己进行命名。
     imp 即 implementation ，表示由编译器生成的、指向实现方法的指针。也就是说，这个指针指向的方法就是我们要添加的方法。
    types 表示我们要添加的方法的返回值和参数。
     */
    
    class_addMethod(kvoClazz, @selector(class), (IMP)kvo_class, types);
    objc_registerClassPair(kvoClazz);
    return kvoClazz;
}

-(BOOL)haseSelector:(SEL)selector {
    Class clazz = object_getClass(self);
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(clazz, &methodCount);
    for (unsigned int i = 0; i < methodCount;  i++) {
        SEL tempMeothod = method_getName(methodList[i]);
        if (tempMeothod == selector) {
            free(methodList);
            return YES;
            
        }
    }
     free(methodList);
    return false;
}
@end































