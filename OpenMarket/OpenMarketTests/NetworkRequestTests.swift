//
//  NetworkRequestTests.swift
//  OpenMarketTests
//
//  Created by Gundy, Wonbi on 2022/11/16.
//

import XCTest
@testable import OpenMarket

final class NetworkRequestTests: XCTestCase {
    var sut: NetworkRequest!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = .none
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
    }
    
    func test_HealthCheckerRequest가_정상적으로URL을반환하는지() {
        // given
        sut = HealthCheckerRequest()
        
        // when
        let result = sut.request?.url
        
        // then
        let expectation = URL(string: "https://openmarket.yagom-academy.kr/healthChecker")
        XCTAssertEqual(result, expectation)
    }
    
    func test_ProductListRequest가_정상적으로URL을반환하는지() {
        // given
        sut = ProductListRequest(pageNo: 1, itemsPerPage: 20, searchValue: "pizza")
        
        // when
        let result = sut.request?.url
        
        // then
        let url: String = "https://openmarket.yagom-academy.kr/api/products?"
        let expectationList = [URL(string: url + "page_no=1&items_per_page=20&search_value=pizza"),
                               URL(string: url + "page_no=1&search_value=pizza&items_per_page=20"),
                               URL(string: url + "items_per_page=20&page_no=1&search_value=pizza"),
                               URL(string: url + "items_per_page=20&search_value=pizza&page_no=1"),
                               URL(string: url + "search_value=pizza&page_no=1&items_per_page=20"),
                               URL(string: url + "search_value=pizza&items_per_page=20&page_no=1")]
        
        XCTAssertTrue(expectationList.contains(result))
    }
    
    func test_ProductDetailRequest가_정상적으로URL을반환하는지() {
        // given
        sut = ProductDetailRequest(productID: 32)
        
        // when
        let result = sut.request?.url
        
        // then
        let expectation = URL(string: "https://openmarket.yagom-academy.kr/api/products/32")
        XCTAssertEqual(result, expectation)
    }
}
