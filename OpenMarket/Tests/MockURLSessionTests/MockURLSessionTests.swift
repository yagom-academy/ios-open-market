//
//  MockURLSessionTests.swift
//  MockURLSessionTests
//
//  Created by Grumpy, OneTool on 2022/05/10.
//

import XCTest

class MockURLSessionTests: XCTestCase {

    var sut: URLSessionGenerator!
    
    override func setUpWithError() throws {
       sut = URLSessionGenerator(session: MockURLSession())
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_서버와_통신하는_대신에_MockData_데이터를_가져오는지() {
        let expt = expectation(description: "waiting for test")
        let successResult: Int = 1
        var pageNumber: Int = 0
        
        sut.sendGet(path: "api/products?page_no=1&items_per_page=10") { data, response, error in
            guard let data = data else {
                return
            }
            let result = try? JSONDecoder().decode(ProductList.self, from: data)
            pageNumber = result!.pageNumber
            expt.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(pageNumber, successResult)
    }

}
