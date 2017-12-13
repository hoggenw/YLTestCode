//
//  UserTest.m
//  UnitTestDemoTests
//
//  Created by 王留根 on 2017/12/12.
//  Copyright © 2017年 王留根. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "User.h"

@interface UserTest : XCTestCase

@property (nonatomic, strong) User * user;

@end

@implementation UserTest

- (void)setUp {
    [super setUp];
    self.user = [User new];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.user = nil;
    [super tearDown];
}

- (void)testExample {
    NSString * test = @"我";
    XCTAssertTrue([self.user isChinese:test],@"不是中文字符");
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
