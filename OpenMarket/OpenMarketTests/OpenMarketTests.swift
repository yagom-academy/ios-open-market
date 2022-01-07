//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by yeha on 2022/01/06.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    var sut: ProductService!

    override func setUpWithError() throws {
        sut = ProductService()
    }

    func test_retrieveProductList_FromSampleData_WithMockURLSession() {
        let expectaion = XCTestExpectation(description: "파싱안됨")

        guard let data = NSDataAsset(name: "products")?.data else {
            return
        }
        print(data)
        guard let result = try? JSONDecoder().decode(ProductList.self, from: data) else {
            return
        }

        sut.retrieveProductList(session: MockURLSession()) { productList in
            print(productList)
            XCTAssertEqual(productList.itemsPerPage, result.itemsPerPage)
            XCTAssertEqual(productList.pages.first?.identification,
                           result.pages.first?.identification)
            XCTAssertEqual(productList.pages.first?.currency, result.pages.first?.currency)
            XCTAssertEqual(productList.pages.first?.createdAt, result.pages.first?.createdAt)

            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 2.0)
    }

    func test_retrieveProduct() {
        let expectaion = XCTestExpectation(description: "파싱안됨")

        sut.retrieveProduct(productIdentification: 87, session: HTTPUtility.defaultSession) { product in
            print(product)
            XCTAssertEqual(product.name, "aladdin")

            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 2.0)
    }
}
