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
    
    func test_JSONDecoder에_잘못된asset을전달했을때_nil을반환하는지() {
        // given
        let asset: String = "yagom"
        
        // when
        let productList = JSONDecoder.decode(ProductList.self, from: asset)
        
        // then
        XCTAssertNil(productList)
    }
    
    func test_JSONDecoder에_잘못된타입을전달했을때_error를던지는지() {
        // given
        let asset: String = "products"
        
        // when
        let product = JSONDecoder.decode(Product.self, from: asset)
        
        // then
        XCTAssertNil(product)
    }
    
    func test_포맷에맞지않은값을_Date로변환하려고하면_nil을반환하는지() {
        // given
        let incorrectString: String = "이천이십이년 십일월 십오일 오후 한 시 이십삼분"
        
        // when
        let date = incorrectString.date()
        
        // then
        XCTAssertNil(date)
    }
}
