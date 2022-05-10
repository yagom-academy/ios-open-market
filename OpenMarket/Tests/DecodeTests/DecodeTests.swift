//
//  DecodeTests.swift
//  DecodeTests
//
//  Created by Grumpy, OneTool on 2022/05/09.
//

import XCTest
@testable import OpenMarket

class DecodeTests: XCTestCase {
    var sut: Parser<ProductList> = Parser<ProductList>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func test_ProductList를_decode_했을때_Asset과_데이터가_일치하는지() {
        // given
        
        // when
        let result: ProductList = sut.decode(name: "products")!
        
        // then
        XCTAssertEqual(result.pageNumber, 1)
    }
}
