//
//  StubURLSessionTests.swift
//  StubURLSessionTests
//
//  Created by papri, Tiana on 11/05/2022.
//

import XCTest
@testable import OpenMarket

class StubURLSessionTests: XCTestCase {
    func test_dataTask할때_dummyResponse받으면_completionHandler실행() {
        //given
        var httpManager = HTTPManager()
        let promise = expectation(description: "dataTask test 성공")
        guard let url = URL(string: "https://market-training.yagom-academy.kr/") else {
            return
        }
        let data = """
        {
            "pages": [
                {
                "id": 20,
                "vendor_id": 3,
                "name": "Test Product",
                "thumbnail":    "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/5a0cd56b6d3411ecabfa97fd953cf965.jpg",
                "currency": "KRW",
                "price": 0,
                "bargain_price": 0,
                "discounted_price": 0,
                "stock": 0,
                "created_at": "2022-01-04T00:00:00.00",
                "issued_at": "2022-01-04T00:00:00.00"
                }
            ]
        }
        """.data(using: .utf8)
        let dummyResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type" : "application/json"])
        let dummyData = DummyData(data: data, response: dummyResponse, error: nil)
        let stubURLSession = StubURLSession(dummyData: dummyData)
        var products: [Product] = []
        
        //when
        let completionHandler: (Data) -> Void = { data in
            do {
                products = try JSONDecoder().decode(OpenMarketProductList.self, from: data).products
            } catch {
                return
            }
            // then
            XCTAssertEqual(products.first?.name, "Test Product")
            promise.fulfill()
        }
        httpManager.urlSession = stubURLSession
        httpManager.loadProductListData(pageNumber: 2, itemsPerPage: 10, completionHandler: completionHandler)
        wait(for: [promise], timeout: 10)
    }
}
