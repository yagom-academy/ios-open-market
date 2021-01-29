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
    
    // MARK: Paser test
    func testDecodeItemsList() throws {
        // 1. given
        let url = try URLManager.makeURL(type: .itemsListPage(1))
        var itemsList: Items?
        let expectation = XCTestExpectation(description: "Wait Decoding")
        
        // 2. when
        Parser<Items>.decodeData(url: url) { result in
            switch result {
            case .success(let object):
                itemsList = object
            case .failure:
                XCTFail("Failed Decoding")
            }
            expectation.fulfill()
        }

        // 3. then
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(itemsList?.page, 1, "It is not equal.")
        XCTAssertEqual(itemsList?.items[0].title, "업로드1", "It is not equal.")
        XCTAssertEqual(itemsList?.items[0].id, 157, "It is not equal.")
        XCTAssertEqual(itemsList?.items[1].id, 163, "It is not equal.")
    }
    
    func testDecodeItem() throws {
        // 1. given
        let url = try URLManager.makeURL(type: .itemId(55))
        var item: Item?
        let expectation = XCTestExpectation(description: "Wait Decoding")
        
        // 2. when
        Parser<Item>.decodeData(url: url) { result in
            switch result {
            case .success(let object):
                item = object
            case .failure:
                XCTFail("Failed Decoding")
            }
            expectation.fulfill()
        }
        
        // 3. then
        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(item?.currency, "USD", "It is not equal.")
        XCTAssertEqual(item?.registrationDate, 1611523563.7406092, "It is not equal.")
        XCTAssertEqual(item?.discountedPrice, 200, "It is not equal.")
    }
    
    
}
