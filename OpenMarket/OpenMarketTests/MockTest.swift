//
//  MockTest.swift
//  OpenMarketTests
//
//  Created by steven on 2021/05/21.
//

import XCTest
@testable import OpenMarket

class MockTest: XCTestCase {

    func test_mock() {
        let networkHelper = NetworkHelper.init(session: MockURLSession())
        
        let promise = expectation(description: "mock test done")
        
        networkHelper.readItem(itemNum: 1) { result in
            switch result {
            case .success(let item):
                XCTAssertEqual(item.id, 1)
            case .failure:
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
}
