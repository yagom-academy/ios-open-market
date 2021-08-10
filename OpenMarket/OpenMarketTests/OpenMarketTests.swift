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
    
    func test_MockApiClient의_getMarketItem_메서드를_통해_page_에_1_전달시_MarketItems에_대한_데이터를_가져올_수_있다() {
        // given
        let page = 1
        let exp = XCTestExpectation(description: "getMarketItems()")
        
        // when
        sut.getMarketItems(for: page) { marketItems in
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
    
    func test_MockApiClient의_getMarketItem_메서드를_통해_page_에_2_전달시_MarketItems에_대한_데이터를_가져올_수_없다() {
        // given
        let page = 2
        let exp = XCTestExpectation(description: "getMarketItems()")
        
        // when
        sut.getMarketItems(for: page) { marketItems in
            guard let data = marketItems else {
                XCTFail("Fail to getMarketItems()")
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
}
