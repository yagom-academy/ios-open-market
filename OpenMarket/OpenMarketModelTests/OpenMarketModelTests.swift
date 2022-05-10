//
//  OpenMarketModelTests.swift
//  OpenMarketModelTests
//
//  Created by 박세리 on 2022/05/10.
//

import XCTest
@testable import OpenMarket

class OpenMarketModelTests: XCTestCase {
    var sut: APIService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = APIService()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_retrieveProductList를호출할때_예상값을반환() {
        // given
        guard let file = NSDataAsset(name: "products") else {
            return
        }
        
        let promise = expectation(description: "")
        let url = URL(string: "https://market-training.yagom-academy.kr/")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let dummy = DummyData(data: file.data, response: response, error: nil)
        let stubUrlSession = StubURLSession(dummy: dummy)
        sut = APIService(urlSession: stubUrlSession)
        
        // when
        sut.retrieveProductList { product in
            let result = try! JSONDecoder().decode(Products.self, from: product)
            let expected = 1
            
            XCTAssertEqual(expected, result.pageNo)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 10)
    }
}
