//
//  MockTest.swift
//  OpenMarketTests
//
//  Created by steven on 2021/05/21.
//

import XCTest
@testable import OpenMarket

class MockTest: XCTestCase {

    func test_mock() {
        let networkHelper = NetworkHelper.init()
        
        let promise = expectation(description: "mock test done")
        
        networkHelper.readItem(itemNum: 1) { result in
            switch result {
            case .success(let item):
                XCTAssertEqual(item.id, 1)
            case .failure:
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_상품_조회() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: configuration)
        let networkHelper = NetworkHelper(session: mockSession)
        
        let data = NSDataAsset(name: "item")?.data
        
        let promise = expectation(description: "Mock test")
        
        MockURLProtocol.requsetHandler = { request in
            let response = HTTPURLResponse(url: URL(string: RequestAddress.readItem(id: 1).url)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (data, response, nil)
        }
        
        networkHelper.readItem(itemNum: 1) { result in
            switch result {
            case .success(let item):
                XCTAssertEqual(item.id, 2)
            case .failure:
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 2)
    }
}
