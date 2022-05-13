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
                message = data
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(message, successResult)
    }
    
    func test_서버와_통신하여_상품_리스트_조회API를_호출하는지() {
        let expectation = expectation(description: "waiting for test")
        let successResult: Int = 1
        var pageNumber: Int = 0
        
        sut.requestListAPI(pageNumber: 1, itemsPerPage: 10) { result in
            switch result {
            case .success(let data):
                pageNumber = data.pageNumber
                
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(pageNumber, successResult)
    }
    
    func test_서버와_통신하여_상품_상세_조회API를_호출하는지() {
        let expectation = expectation(description: "waiting for test")
        let successResult: String = "아이폰13"
        var name: String = ""
        
        sut.requestDetailAPI(productId: 522) { result in
            switch result {
            case .success(let data):
                name = data.name
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(name, successResult)
    }
    
    func test_상품_상세_조회API를_호출했을때_Currency타입으로_Decode_성공하는지() {
        let expectation = expectation(description: "waiting for test")
        let successResult: Currency? = Currency(rawValue: "KRW")
        var currency: Currency?
        
        sut.requestDetailAPI(productId: 522) { result in
            switch result {
            case .success(let data):
                currency = data.currency
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(currency, successResult)
    }
    
    func test_상품_상세_조회API를_호출했을때_Date타입으로_Decode_성공하는지() {
        let expectation = expectation(description: "waiting for test")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SS"
        let successResult: Date? = dateFormatter.date(from: "2022-01-18T00:00:00.00")
        var createdAt: Date?
        
        sut.requestDetailAPI(productId: 522) { result in
            switch result {
            case .success(let data):
                createdAt = data.createdAt
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(createdAt, successResult)
    }
}
