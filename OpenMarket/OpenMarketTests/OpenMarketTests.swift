//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by papri, Tiana on 2022/05/10.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    func test_parse할때_파일이름이올바르면_OpenMarketService반환() {
        // given
        let fileName = "products"
        // when, then
        XCTAssertNoThrow(try OpenMarketProductList.parse(fileName: fileName))
    }
    
    func test_parse할때_파일이름이올바르면_Product배열반환() throws {
        // given
        let fileName = "products"
        // when
        let firstProduct = try OpenMarketProductList.parse(fileName: fileName).products.first
        // then
        XCTAssertEqual(firstProduct?.name, "Test Product")
    }

}
