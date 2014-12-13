//
//  OperatorTests.swift
//  BrynSwift
//
//  Created by bryn austin bellomy on 2014 Dec 10.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Cocoa
import XCTest
import BrynSwift

class OperatorTests: XCTestCase
{
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample()
    {
        // This is an example of a functional test case.

        var maybeIntEmpty : Int?
        var maybeIntFull : Int? = 6

        var asdf : Int?
        asdf ??= maybeIntFull
        asdf =?? 67
        asdf ??= 234

    }

    func testCurryAndSwapOperator()
    {
        let someStrings = ["FIRST", "SECOND", "THIRD"]
        let lowercaseStrings = someStrings |> curry_swapargs2(map)({ $0.lowercaseString })
        XCTAssert(lowercaseStrings[0] == "first")
        XCTAssert(lowercaseStrings[1] == "second")
        XCTAssert(lowercaseStrings[2] == "third")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
