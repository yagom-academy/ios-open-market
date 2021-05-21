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
    }
}
