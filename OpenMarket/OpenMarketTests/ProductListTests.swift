//
//  ProductListTests.swift
//  OpenMarketTests
//  Created by SummerCat & Bella on 2022/11/15.

import XCTest
@testable import OpenMarket

final class ProductListTests: XCTestCase {
    
    var sut: ProductList!
    
    let decoder = JSONDecoder()
    let dataAsset: NSDataAsset = NSDataAsset(name: "products")!

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = try decoder.decode(ProductList.self, from: dataAsset.data)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_pageNumber가_1인지() {
        // then
        XCTAssertEqual(sut.pageNumber, 1)
    }
    
    func test_itemsPerPage가_20인지() {
        // then
        XCTAssertEqual(sut.itemsPerPage, 20)
    }
}
