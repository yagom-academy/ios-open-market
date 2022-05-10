//
//  ProductCatalogTests.swift
//  ProductCatalogTests
//
//  Created by song on 2022/05/10.
//

import XCTest

class ProductCatalogTests: XCTestCase {
    
    func test_asset이_products이고_result를_Decode했을때_결과가_nil이_아닌지() {
        //given
        let asset = "products"
        //when
        let result = ParseManager<ProductCatalog>.parse(name: asset)
        //then
        XCTAssertNotNil(result)
    }
    
    func test_data가_팥빙수이고_result를_Decode했을때_결과가_pages의_마지막_name과_같은지() {
        //given
        let data = "팥빙수"
        //when
        let result = ParseManager<ProductCatalog>.parse(name: "products")
        //then
        XCTAssertEqual(result?.pages?.last?.name, data)
    }
    
    func test_data가_10이고_result를_Decode했을때_결과가_pages의_갯수가_data와_같은지() {
        //given
        let data = 10
        //when
        let result = ParseManager<ProductCatalog>.parse(name: "products")
        //then
        XCTAssertEqual(result?.pages?.count, data)
    }
}
