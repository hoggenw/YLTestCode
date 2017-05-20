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
#import "FooView.h"

@interface ViewController ()

@end

@implementation ViewController


//我们可以在运行时添加新的selector，也可以在运行时获取已存在的selector，我们可以通过下面三种方法来获取SEL:
//
//sel_registerName函数
//
//Objective-C编译器提供的@selector()
//
//NSSelectorFromString()方法
- (void)viewDidLoad {
    [super viewDidLoad];
    FooView * fooView = [[FooView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width,200)];
    fooView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:fooView];
    [fooView setTapActionWithBlock:^{
        NSLog(@"say something baby");
    }];
    

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
    
    
    // 调用指定方法的实现
    //id method_invoke ( id receiver, Method m, ... );
    
    // 调用返回一个数据结构的方法的实现
   // void method_invoke_stret ( id receiver, Method m, ... );
    
    // 获取方法名
    SEL method_getName ( Method m );
    
    // 返回方法的实现
    IMP method_getImplementation ( Method m );
    
    // 获取描述方法参数和返回值类型的字符串
    const char * method_getTypeEncoding ( Method m );
    
    // 获取方法的返回值类型的字符串
    char * method_copyReturnType ( Method m );
    
    // 获取方法的指定位置参数的类型字符串
    char * method_copyArgumentType ( Method m, unsigned int index );
    
    // 通过引用返回方法的返回值类型字符串
    void method_getReturnType ( Method m, char *dst, size_t dst_len );
    
    // 返回方法的参数的个数
    unsigned int method_getNumberOfArguments ( Method m );
    
    // 通过引用返回方法指定位置参数的类型字符串
    void method_getArgumentType ( Method m, unsigned int index, char *dst, size_t dst_len );
    
    // 返回指定方法的方法描述结构体
    struct objc_method_description * method_getDescription ( Method m );
    
    // 设置方法的实现
    IMP method_setImplementation ( Method m, IMP imp );
    
    // 交换两个方法的实现
    void method_exchangeImplementations ( Method m1, Method m2 );

    // 返回给定选择器指定的方法的名称
    const char * sel_getName ( SEL sel );
    
    // 在Objective-C Runtime系统中注册一个方法，将方法名映射到一个选择器，并返回这个选择器
    SEL sel_registerName ( const char *str );
    
    // 在Objective-C Runtime系统中注册一个方法
    SEL sel_getUid ( const char *str );
    
    // 比较两个选择器
    BOOL sel_isEqual ( SEL lhs, SEL rhs );
    // 返回指定的协议
    Protocol * objc_getProtocol ( const char *name );
    
    // 获取运行时所知道的所有协议的数组
  //  Protocol ** objc_copyProtocolList ( unsigned int *outCount );
    
    // 创建新的协议实例
    Protocol * objc_allocateProtocol ( const char *name );
    
    // 在运行时中注册新创建的协议
    void objc_registerProtocol ( Protocol *proto );
    
    // 为协议添加方法
    void protocol_addMethodDescription ( Protocol *proto, SEL name, const char *types, BOOL isRequiredMethod, BOOL isInstanceMethod );
    
    // 添加一个已注册的协议到协议中
    void protocol_addProtocol ( Protocol *proto, Protocol *addition );
    
    // 为协议添加属性
    void protocol_addProperty ( Protocol *proto, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount, BOOL isRequiredProperty, BOOL isInstanceProperty );
    
    // 返回协议名
    const char * protocol_getName ( Protocol *p );
    
    // 测试两个协议是否相等
    BOOL protocol_isEqual ( Protocol *proto, Protocol *other );
    
    // 获取协议中指定条件的方法的方法描述数组
    struct objc_method_description * protocol_copyMethodDescriptionList ( Protocol *p, BOOL isRequiredMethod, BOOL isInstanceMethod, unsigned int *outCount );
    
    // 获取协议中指定方法的方法描述
    struct objc_method_description protocol_getMethodDescription ( Protocol *p, SEL aSel, BOOL isRequiredMethod, BOOL isInstanceMethod );
    
    // 获取协议中的属性列表
    objc_property_t * protocol_copyPropertyList ( Protocol *proto, unsigned int *outCount );
    
    // 获取协议的指定属性
    objc_property_t protocol_getProperty ( Protocol *proto, const char *name, BOOL isRequiredProperty, BOOL isInstanceProperty );
    
    // 获取协议采用的协议
   // Protocol ** protocol_copyProtocolList ( Protocol *proto, unsigned int *outCount );
    
    // 查看协议是否采用了另一个协议
    BOOL protocol_conformsToProtocol ( Protocol *proto, Protocol *other );
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





















