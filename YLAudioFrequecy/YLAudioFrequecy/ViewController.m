//
//  ViewController.m
//  YLAudioFrequecy
//
//  Created by 王留根 on 17/2/22.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TestRuntime.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL * url = [NSURL URLWithString:@"http://fdfs.xmcdn.com/group25/M0B/92/53/wKgJNlims-vgpIJLADSwZ4QElcA333.mp3"];
    AVPlayerItem * songItem = [[AVPlayerItem alloc] initWithURL:url];
    AVPlayer * player = [[AVPlayer alloc] initWithPlayerItem:songItem];
    [player play];

    // 获取类的类名
    const char *class_getName(Class cls);
    // 获取类的父类
    Class class_getSuperclass ( Class cls );
    
    // 判断给定的Class是否是一个元类
    BOOL class_isMetaClass ( Class cls );
    // 获取指定的属性
    objc_property_t class_getProperty ( Class cls, const char *name );
    
    // 获取属性列表
    objc_property_t * class_copyPropertyList ( Class cls, unsigned int *outCount );
    
    // 为类添加属性
    BOOL class_addProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );
    
    // 替换类的属性
    void class_replaceProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );
    
    // 添加方法
    BOOL class_addMethod ( Class cls, SEL name, IMP imp, const char *types );
    
    // 获取实例方法
    Method class_getInstanceMethod ( Class cls, SEL name );
    
    // 获取类方法
    Method class_getClassMethod ( Class cls, SEL name );
    
    // 获取所有方法的数组
    Method * class_copyMethodList ( Class cls, unsigned int *outCount );
    
    // 替代方法的实现
    IMP class_replaceMethod ( Class cls, SEL name, IMP imp, const char *types );
    
    // 返回方法的具体实现
    IMP class_getMethodImplementation ( Class cls, SEL name );
    IMP class_getMethodImplementation_stret ( Class cls, SEL name );
    
    // 类实例是否响应指定的selector
    BOOL class_respondsToSelector ( Class cls, SEL sel );
    
    TestRuntime * runtime = [[TestRuntime alloc] init];
    unsigned int outCount = 0;
    Class cls = runtime.class;
    //类名
    NSLog(@"class name : %s", class_getName(cls));
    NSLog(@"==========================================================\n");
    //父类
    NSLog(@"super class name: %s", class_getName(class_getSuperclass(cls)));
    NSLog(@"==========================================================\n");
    //是否是元lei
    NSLog(@"TestRuntime is %@ a meta_class", (class_isMetaClass(cls)? @"" : @"not"));
    NSLog(@"==========================================================\n");
    
    Class meta_class = objc_getMetaClass(class_getName(cls));
    NSLog(@"%s's meta-class is %s", class_getName(cls), class_getName(meta_class));
    NSLog(@"==========================================================\n");
    //变量实例大小
    NSLog(@"instance size : %zu",class_getInstanceSize(cls));
    NSLog(@"==========================================================\n");
    //成员变量
    //获取全部成员变量
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance variavle's name: %s at index: %d",ivar_getName(ivar),i);
    }
    free(ivars);
    Ivar string = class_getInstanceVariable(cls, "_string");
    if (string != NULL) {
        NSLog(@"instance varible %s", ivar_getName(string));
    }
    
    NSLog(@"==========================================================\n");
    //属性操作
    //获取property成员变量
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name: %s at index: %d",property_getName(property),i);
    }

    free(properties);
    objc_property_t array = class_getProperty(cls, "array");
    if (array != NULL) {
        NSLog(@"property %s",property_getName(array));
    }
    NSLog(@"==========================================================\n");

    //方法操作
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++){
        Method method = methods[i];
        NSLog(@"method's signature: %s", method_getName(method));
    }
    free(methods);
    
    Method method1 = class_getInstanceMethod(cls, @selector(method1));
    if (method1 != NULL) {
        NSLog(@"method %s", method_getName(method1));
    }
    
    Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
    if (classMethod != NULL) {
        NSLog(@"class method s",method_getName(classMethod));
    }
    NSLog(@"Testruntime is %@ respond to selector: methodsWithArg1:arg2:",class_respondsToSelector(cls, @selector(method3WithArg1:arg2:))? @"" : @"not");
    IMP imp = class_getMethodImplementation(cls, @selector(method1));
    imp();
    
    NSLog(@"==========================================================\n");
    //协议
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(cls, &outCount);
    Protocol * protocol;
    for (int i = 0; i < outCount; i++) {
        protocol = protocols[i];
        NSLog(@"protocol name: %s", protocol_getName(protocol));
    }
    NSLog(@"MyClass is%@ responsed to protocol %s", class_conformsToProtocol(cls, protocol) ? @"" : @" not", protocol_getName(protocol));
    
    NSLog(@"==========================================================");
    [self aboutClass];
    [self typeEncoding];
    

    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)aboutClass {
    // 创建一个新类和元类
    //objc_allocateClassPair函数：如果我们要创建一个根类，则superclass指定为Nil。extraBytes通常指定为0，该参数是分配给类和元类对象尾部的索引ivars的字节数。
    Class objc_allocateClassPair ( Class superclass, const char *name, size_t extraBytes );
    
    // 销毁一个类及其相关联的类
    //objc_disposeClassPair函数用于销毁一个类，不过需要注意的是，如果程序运行中还存在类或其子类的实例，则不能调用针对类调用该方法。
    void objc_disposeClassPair ( Class cls );
    
    // 在应用中注册由objc_allocateClassPair创建的类
    //。然后使用诸如class_addMethod，class_addIvar等函数来为新创建的类添加方法、实例变量和属性等。完成这些后，我们需要调用objc_registerClassPair函数来注册类，之后这个新类就可以在程序中使用了。
    void objc_registerClassPair ( Class cls );
    NSLog(@"======================== about class ==================================");
    Class cls = objc_allocateClassPair(TestRuntime.class, "subClass", 0);
    class_addMethod(cls, @selector(submethod1), (IMP)imp_submethod1, "v@:");
    class_replaceMethod(cls, @selector(method1), (IMP)imp_submethod1, "v@:");
    class_addIvar(cls, "_ivar1", sizeof(NSString *), log(sizeof(NSString *)), "i");
    
    objc_property_attribute_t type = {"T","@\"NSString\""};
    objc_property_attribute_t ownership = {"C",""};
    objc_property_attribute_t backingivar = {"V","_ivar1"};
    objc_property_attribute_t attrs[] = {type,ownership,backingivar};
    
    class_addProperty(cls, "property2", attrs, 3);
    objc_registerClassPair(cls);
    
    id instanc = [[cls alloc] init];
    [instanc performSelector:@selector(submethod1)];
    [instanc performSelector:@selector(method1)];
    // 获取已注册的类定义的列表
    int objc_getClassList ( Class *buffer, int bufferCount );
    
    // 创建并返回一个指向所有已注册类的指针列表
    Class * objc_copyClassList ( unsigned int *outCount );
    
    // 返回指定类的类定义
    Class objc_lookUpClass ( const char *name );
    Class objc_getClass ( const char *name );
    Class objc_getRequiredClass ( const char *name );
    
    // 返回指定类的元类
    Class objc_getMetaClass ( const char *name );
    

    
}

-(void)typeEncoding{
     NSLog(@"======================== type encodeing ==================================");
    float a[] = {1.0, 2.0, 3.0};
    NSLog(@"array encoding type: %s", @encode(typeof(a)));
    NSArray * array = @[@"ddsd",@"sadas"];
    NSLog(@"array encoding type: %s", @encode(typeof(array)));
}

void imp_submethod1(id self,SEL _cmd){
    NSLog(@"say hello to me now");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end





















