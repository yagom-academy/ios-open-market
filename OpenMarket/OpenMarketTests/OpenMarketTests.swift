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
        sut.getMarketPageItems(for: page) { result in
            switch result {
            case .success(let marketdata):
                let expectedResult = false
                let result = marketdata.items.isEmpty
                // then
                XCTAssertEqual(result, expectedResult)
            case .failure(let error):
                if let apiError = error as? ApiError {
                    XCTFail(apiError.localizedDescription)
                }
                if let parsingError = error as? ParsingError {
                    XCTFail(parsingError.localizedDescription)
                }
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
    
    func test_MockApiClient의_getMarketPageItems_메서드를_통해_page_에_2_전달시_MarketPageItems에_대한_데이터를_가져올_수_없다() {
        // given
        let page = 1
        let exp = XCTestExpectation(description: "getMarketPageItems()")

        // when
        sut.getMarketPageItems(for: page) { result in
            switch result {
            case .success(let marketdata):
                let expectedResult = false
                let result = marketdata.items.isEmpty
                // then
                XCTAssertEqual(result, expectedResult)
            case .failure(let error):
                if let apiError = error as? ApiError {
                    XCTFail(apiError.localizedDescription)
                }
                if let parsingError = error as? ParsingError {
                    XCTFail(parsingError.localizedDescription)
                }
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }

    func test_MockApiClient의_getMarketItem_메서드를_통해_id_에_1_전달시_MarketItems에_대한_title_값은_MacBook_공백_Pro_이다() {
        // given
        let id = 1
        let exp = XCTestExpectation(description: "getMarketItem()")
        // when
        sut.getMarketItem(for: id) { result in
            switch result {
            case .success(let marketdata):
                let expectedResult = "MacBook Pro"
                let result = marketdata.title
                // then
                XCTAssertEqual(result, expectedResult)
            case .failure(let error):
                if let apiError = error as? ApiError {
                    XCTFail(apiError.localizedDescription)
                }
                if let parsingError = error as? ParsingError {
                    XCTFail(parsingError.localizedDescription)
                }
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }

    func test_MockApiClient의_getMarketItem_메서드를_통해_id_에_2_전달시_MarketItems에_대한_값을_가져올수없다() {
        // given
        let id = 2
        let exp = XCTestExpectation(description: "getMarketItem()")
        // when
        sut.getMarketItem(for: id) { result in
            switch result {
            case .success(let marketdata):
                let expectedResult = "MacBook Pro"
                let result = marketdata.title
                // then
                XCTAssertEqual(result, expectedResult)
            case .failure(let error):
                if let apiError = error as? ApiError {
                    XCTFail(apiError.localizedDescription)
                }
                if let parsingError = error as? ParsingError {
                    XCTFail(parsingError.localizedDescription)
                }
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
}
