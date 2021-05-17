//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Seungjin Baek on 2021/05/12.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {

    var itemList: ItemListVO?
    
    override func setUp() {
        super.setUp()
        itemList = ItemListVO()
    }
    
    override func tearDown() {
        super.tearDown()
        itemList = nil
    }
    
    func test2() {
        let testString: String?
        testString = nil
        XCTAssertNil(testString)
        XCTAssertNotNil(testString)
    }
    

}
