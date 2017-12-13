//
//  UnitTestDemoTests.m
//  UnitTestDemoTests
//
//  Created by 王留根 on 2017/12/12.
//  Copyright © 2017年 王留根. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface UnitTestDemoTests : XCTestCase

@property(nonatomic,strong)ViewController *testVC;

@end

/**
 XCTFail(format…)  //生成一个失败的测试；
 XCTAssertNil(a1, format...)  //为空判断，a1为空时通过，反之不通过；
 XCTAssertNotNil(a1, format…) //不为空判断，a1不为空时通过，反之不通过；
 XCTAssert(expression, format...) //当expression求值为TRUE时通过；
 XCTAssertTrue(expression, format...) //当expression求值为TRUE时通过；
 XCTAssertFalse(expression, format...)  //当expression求值为False时通过；
 XCTAssertEqualObjects(a1, a2, format...)  //判断相等，[a1 isEqual:a2]值为TRUE时通过，其中一个不为空时，不通过；
 XCTAssertNotEqualObjects(a1, a2, format...)  //判断不等，[a1 isEqual:a2]值为False时通过；
 XCTAssertEqual(a1, a2, format...)  //判断相等（当a1和a2是 C语言标量、结构体或联合体时使用,实际测试发现NSString也可以）；
 XCTAssertNotEqual(a1, a2, format...)  //判断不等（当a1和a2是 C语言标量、结构体或联合体时使用）；
 XCTAssertEqualWithAccuracy(a1, a2, accuracy, format...)  //判断相等，（double或float类型）提供一个误差范围，当在误差范围（+/-accuracy）以内相等时通过测试；
 XCTAssertNotEqualWithAccuracy(a1, a2, accuracy, format...)   //判断不等，（double或float类型）提供一个误差范围，当在误差范围以内不等时通过测试；
 XCTAssertThrows(expression, format...)  //异常测试，当expression发生异常时通过；反之不通过；
 XCTAssertThrowsSpecific(expression, specificException, format...)  //异常测试，当expression发生specificException异常时通过；反之发生其他异常或不发生异常均不通过；
 XCTAssertThrowsSpecificNamed(expression, specificException, exception_name, format...)  //异常测试，当expression发生具体异常、具体异常名称的异常时通过测试，反之不通过；
 XCTAssertNoThrow(expression, format…)  //异常测试，当expression没有发生异常时通过测试；
 XCTAssertNoThrowSpecific(expression, specificException, format...)  //异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过；
 XCTAssertNoThrowSpecificNamed(expression, specificException, exception_name, format...)  //异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过
 */

@implementation UnitTestDemoTests

- (void)setUp {
    [super setUp];
    self.testVC = [ViewController new];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.testVC = nil;
    [super tearDown];
}

- (void)testExample {
    
    int result = [_testVC getMaxNUmber: 100];
    XCTAssertEqual(100, result,@"测试不通过");
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//        for (int i = 0; i <= 3; i ++) {
//            for (int j = 0;  j <= 5;  j++) {
//                NSLog(@"jj");
//            }
//            NSLog(@"ii");
//        }
//    }];
//}

@end
