//
//  UnitTextUIDemoTests.swift
//  UnitTextUIDemoTests
//
//  Created by 王留根 on 2017/12/11.
//  Copyright © 2017年 王留根. All rights reserved.
//

import XCTest
@testable import UnitTextUIDemo

class UnitTextUIDemoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        testScoreIsComputed();
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testScoreIsComputed() {
        
        print("自定义测试testExample");
        let  a = 3;
        XCTAssertTrue(a == 0,"a 不能等于 0");
        XCTAssertEqual(a, 95, "Score computed from guess is wrong")
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
