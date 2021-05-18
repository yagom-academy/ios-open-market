//
//  NetworkHelperTest.swift
//  OpenMarketTests
//
//  Created by steven on 2021/05/18.
//

import XCTest

@testable import OpenMarket
class NetworkHelperTest: XCTestCase { 

    func test_요청_url_생성() {
        XCTAssertEqual(RequestAddress.createItem.url, "")
    }

}
