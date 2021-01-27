//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 김태형 on 2021/01/25.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {

    func testPageOne() {
        guard let productList = testGetProductList(page: 1) else {
            return
        }
        print(productList)
        XCTAssertEqual(productList.page, 1)
        XCTAssertEqual(productList.items.count, 20)
    }
    
    func testPageTwo() {
        guard let productList = testGetProductList(page: 2) else {
            return
        }
        print(productList)
        XCTAssertEqual(productList.page, 2)
        XCTAssertEqual(productList.items.count, 20)
    }
    
    func testPageThree() {
        guard let productList = testGetProductList(page: 3) else {
            return
        }
        print(productList)
        XCTAssertEqual(productList.page,3)
        XCTAssertEqual(productList.items.count, 20)
    }
    
    func testGetProductList(page: Int) -> ProductList? {
        let manager = OpenMarketAPIManager()
        let pause = XCTestExpectation(description: "wait")
        var productlist: ProductList?

        let urlRequest = manager.makeProductListRequestURL(of: page)
        manager.fetchProductList(with: urlRequest) { result in
            switch result {
            case .success(let data):
                productlist = data
            case .failure(let error):
                print(error)
            }
            pause.fulfill()
        }
        wait(for: [pause], timeout: 5)

        XCTAssertNotNil(productlist)
        return productlist
    }

}
