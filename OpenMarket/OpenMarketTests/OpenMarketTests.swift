//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 김동빈 on 2021/01/25.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }

    func testMakeItemsListURL() throws {
        // 1. given
        let expectResult = URL(string: "https://camp-open-market.herokuapp.com/items/1")
        
        // 2. when
        let url = try URLManager.makeURL(type: .itemsListPage(1))
        
        // 3. then
        XCTAssertEqual(url, expectResult, "Making URL is Failed")
    }
    
    func testMakeRegistItemURL() throws {
        // 1. given
        let expectResult = URL(string: "https://camp-open-market.herokuapp.com/item")
        
        // 2. when
        let url = try URLManager.makeURL(type: .registItem)
        
        // 3. then
        XCTAssertEqual(url, expectResult, "Making URL is Failed")
    }
    
    func testMakeItemIdURL() throws {
        // 1. given
        let expectResult = URL(string: "https://camp-open-market.herokuapp.com/item/66")
        
        // 2. when
        let url = try URLManager.makeURL(type: .itemId(66))
        
        // 3. then
        XCTAssertEqual(url, expectResult, "Making URL is Failed")
    }
    
}
