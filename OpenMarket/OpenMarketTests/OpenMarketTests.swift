//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import XCTest
@testable import OpenMarket

final class OpenMarketTests: XCTestCase {
    func test_ProductList타입의파싱이_정상적으로되는지() {
        // given
        
        // when
        let productList = JSONDecoder.decode(ProductList.self, from: "products")
        
        // then
        XCTAssertNotNil(productList)
    }
    
    func test_파싱된ProductList타입의데이터가_실제데이터와일치하는지() {
        // given
        let pageNo: Int = 1
        let incorrectPageNo: Int = 2
        let limit: Int = 20
        
        // when
        let productList = JSONDecoder.decode(ProductList.self, from: "products")
        
        // then
        XCTAssertEqual(productList?.pageNo, pageNo)
        XCTAssertEqual(productList?.limit, limit)
        XCTAssertNotEqual(productList?.pageNo, incorrectPageNo)
    }
    
    func test_파싱된ProductList타입의데이터안에_Product타입이정상적으로들어있는지() {
        // given
        let productID: Int = 15
        let productName: String = "pizza"
        
        // when
        let productList = JSONDecoder.decode(ProductList.self, from: "products")
        let pizza = productList?.pages.filter { $0.id == productID }.first
        
        // then
        XCTAssertNotNil(productList?.pages)
        XCTAssertNotNil(pizza)
        XCTAssertEqual(pizza?.name, productName)
    }
    
    func test_Product타입의연산프로퍼티가_정상적으로Date를생성하는지() {
        // given
        let productID: Int = 15
        let productCreatedAt: String = "2021-12-29T00:00:00.00"
        let productIssuedAt: String = "2021-12-29T00:00:00.00"
        
        // when
        let productList = JSONDecoder.decode(ProductList.self, from: "products")
        let pizza = productList?.pages.filter { $0.id == productID }.first
        
        let pizzaCreatedDate = pizza?.createdDate
        let pizzaIssuedDate = pizza?.issuedDate
        
        // then
        XCTAssertNotNil(pizzaCreatedDate)
        XCTAssertEqual(pizzaCreatedDate, productCreatedAt.date())
        XCTAssertNotNil(pizzaIssuedDate)
        XCTAssertEqual(pizzaIssuedDate, productIssuedAt.date())
    }
}
