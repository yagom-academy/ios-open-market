//
//  MockOpenMarketTest.swift
//  OpenMarketTests
//
//  Created by yeha on 2022/01/07.
//

import XCTest
@testable import OpenMarket

class MockOpenMarketTest: XCTestCase {
    var sut: ProductService!

    override func setUpWithError() throws {
        sut = ProductService()
    }

    func test_retrieveProductList_FromSampleData_WithMockURLSession() {
        let expectaion = XCTestExpectation(description: "")
        guard let data = NSDataAsset(name: "products")?.data else {
            return
        }
        guard let sampleDecodedData = try? JSONDecoder().decode(
            ProductList.self,
            from: data
        ) else {
            return
        }

        sut.retrieveProductList(session: MockURLSession()) { result in
            switch result {
            case .success(let decodedData):
                XCTAssertEqual(decodedData.itemsPerPage, sampleDecodedData.itemsPerPage)
                XCTAssertEqual(decodedData.pages.first?.identification,
                               sampleDecodedData.pages.first?.identification)
                XCTAssertEqual(decodedData.pages.first?.currency,
                               sampleDecodedData.pages.first?.currency)
                XCTAssertEqual(decodedData.pages.first?.createdAt,
                               sampleDecodedData.pages.first?.createdAt)
            case .failure:
                XCTFail("통신 실패")
            }
            expectaion.fulfill()
        }
        wait(for: [expectaion], timeout: 2.0)
    }
}
