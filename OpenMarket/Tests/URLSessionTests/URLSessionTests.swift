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
        sut.requestHealthCheckerAPI() { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, "OK")
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func test_서버와_통신하여_상품_리스트_조회API를_호출하는지() {
        sut.requestListAPI(pageNum: 1, items_per_page: 10) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.pageNumber, 1)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func test_서버와_통신하여_상품_상세_조회API를_호출하는지() {
        sut.requestDetailAPI(product_id: 522) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.name, "아이폰13")
            case .failure(_):
                XCTFail()
            }
        }
    }
}
