//
//  Vector2DTestCase.swift
//  DrawingSimulation
//
//  Created by Robert Dickerson on 7/29/15.
//  Copyright (c) 2015 Robert Dickerson. All rights reserved.
//

import UIKit
import XCTest

import DrawingSimulation

class Vector2DTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testAdd() {
        let a = Vector2D(x: 2.0, y: 3.0)
        let b = Vector2D(x: 5.0, y: 2.0)
        
        let c = a + b
        
        XCTAssert(c.x == 7.0 && c.y == 5.0, "Pass")
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
