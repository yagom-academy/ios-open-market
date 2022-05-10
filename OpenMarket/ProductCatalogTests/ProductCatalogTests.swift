//
//  ProductCatalogTests.swift
//  ProductCatalogTests
//
//  Created by song on 2022/05/10.
//

import XCTest
@testable import OpenMarket

class ProductCatalogTests: XCTestCase {
    
    var sut: ProductCatalog?
    
    override func setUp() {
        sut = ProductCatalog.parse(name: "products")
    }
    
    override func tearDown() {
        sut = nil
    }

    func test_data가_팥빙수이고_result를_Decode했을때_결과가_pages의_마지막_name과_같은지() {
        //given
        let data = "팥빙수"
        //when
        let result = sut?.pages?.last?.name
        //then
        XCTAssertEqual(result, data)
    }
    
    func test_data가_10이고_result를_Decode했을때_결과가_pages의_갯수가_data와_같은지() {
        //given
        let data = 10
        //when
        let result = sut?.pages?.count
        //then
        XCTAssertEqual(result, data)
    }
}
