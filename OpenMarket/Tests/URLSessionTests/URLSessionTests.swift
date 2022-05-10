//
//  URLSessionTests.swift
//  URLSessionTests
//
//  Created by Grumpy, OneTool on 2022/05/10.
//

import XCTest

class URLSessionTests: XCTestCase {

    var sut: RequestAssistant!
    
    override func setUpWithError() throws {
        sut = RequestAssistant()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_서버와_통신하여_HealthCheckerAPI를_호출하는지() {
        let expectation = expectation(description: "waiting for test")
        let successResult: String = "\"OK\""
        var message: String = ""
        
        sut.requestHealthCheckerAPI() { result in
            switch result {
            case .success(let data):
                print(data)
                message = data
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(message, successResult)
    }
    
    func test_서버와_통신하여_상품_리스트_조회API를_호출하는지() {
        let expectation = expectation(description: "waiting for test")
        let successResult: Int = 1
        var pageNumber: Int = 0
        
        sut.requestListAPI(pageNum: 1, items_per_page: 10) { result in
            switch result {
            case .success(let data):
                pageNumber = data.pageNumber
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(pageNumber, successResult)
    }
    
    func test_서버와_통신하여_상품_상세_조회API를_호출하는지() {
        let expectation = expectation(description: "waiting for test")
        let successResult: String = "아이폰13"
        var name: String = ""
        
        sut.requestDetailAPI(product_id: 522) { result in
            switch result {
            case .success(let data):
                name = data.name
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(name, successResult)
    }
}
