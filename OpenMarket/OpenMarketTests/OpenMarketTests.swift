//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by YongHoon JJo on 2021/08/10.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    var sut: MockApiClient!
    
    override func setUp() {
        sut = MockApiClient()
    }
    
    func test_MockApiClient의_getMarketPageItems_메서드를_통해_page_에_1_전달시_MarketPageItems에_대한_데이터를_가져올_수_있다() {
        // given
        let page = 1
        let exp = XCTestExpectation(description: "getMarketItems()")
        
        // when
        sut.getMarketPageItems(for: page) { marketItems in
            guard let data = marketItems else {
                XCTFail("Fail to getMarketItems()")
                return
            }
            let expectedResult = false
            let result = data.items.isEmpty
            // then
            XCTAssertEqual(result, expectedResult)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
    
    func test_MockApiClient의_getMarketPageItems_메서드를_통해_page_에_2_전달시_MarketPageItems에_대한_데이터를_가져올_수_없다() {
        // given
        let page = 2
        let exp = XCTestExpectation(description: "getMarketPageItems()")
        
        // when
        sut.getMarketPageItems(for: page) { marketItems in
            guard let data = marketItems else {
                XCTFail("Fail to getMarketPageItems()")
                exp.fulfill()
                return
            }
            let expectedResult = false
            let result = data.items.isEmpty
            // then
            XCTAssertEqual(result, expectedResult)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
    
    func test_MockApiClient의_getMarketItem_메서드를_통해_id_에_1_전달시_MarketItems에_대한_title_값은_MacBook_공백_Pro_이다() {
        // given
        let id = 1
        let exp = XCTestExpectation(description: "getMarketItem()")
        // when
        sut.getMarketItem(for: id) { marketItem in
            guard let item = marketItem else {
                XCTFail("Fail to getMarketItem()")
                exp.fulfill()
                return
            }
            let expectedResult = "MacBook Pro"
            let result = item.title
            // then
            XCTAssertEqual(result, expectedResult)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
    
    func test_MockApiClient의_getMarketItem_메서드를_통해_id_에_2_전달시_MarketItems에_대한_값을_가져올수없다() {
        // given
        let id = 2
        let exp = XCTestExpectation(description: "getMarketItem()")
        // when
        sut.getMarketItem(for: id) { marketItem in
            guard let item = marketItem else {
                XCTFail("Fail to getMarketItem()")
                exp.fulfill()
                return
            }
            let expectedResult = "MacBook Pro"
            let result = item.title
            // then
            XCTAssertEqual(result, expectedResult)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
}
