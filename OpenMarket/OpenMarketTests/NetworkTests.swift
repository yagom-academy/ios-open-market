//
//  NetworkTests.swift
//  NetworkTests
//
//  Created by dudu, safari on 2022/05/09.
//

import XCTest

@testable import OpenMarket

class NetworkTests: XCTestCase {
    var sut: API!
    
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}
    
    func test_네트워크에_서버상태요청시_OK가_넘어오는지() {
        // given
        let promise = expectation(description: "will return OK message")
        sut = API.serverState
        
        // when
        sut.checkServerState { result in
            // then
            switch result {
            case .success(let text):
                XCTAssertEqual("OK", text)
            case .failure(_):
                XCTAssert(false, "에러 발생하면 안됨")
            }
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 10)
    }
    
    func test_네트워크에_productList데이터_요청시_올바른값이_넘어오는지() {
        // given
        let promise = expectation(description: "will return productList")
        sut = API.requestList
        
        // when
        sut.getData(page: 1, itemsPerPage: 10) { result in
            // then
            switch result {
            case .success(let list):
                XCTAssertEqual(list.pageNo, 1)
                XCTAssertEqual(list.itemsPerPage, 10)
                XCTAssertEqual(list.totalCount, 1368)
            case .failure(_):
                XCTAssert(false, "에러 발생하면 안됨")
            }
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 10)
    }
    
    func test_네트워크에_product요청시_올바른값이_넘어오는지() {
        // given
        let promise = expectation(description: "will return product")
        sut = API.requestProduct
 
        // when
        sut.getData(id: 2072) { result in
            // then
            switch result {
            case .success(let product):
                XCTAssertEqual(product.id, 2072)
                XCTAssertEqual(product.vendorId, 14)
                XCTAssertEqual(product.name, "123123")
            case .failure(_):
                XCTAssert(false, "에러 발생하면 안됨")
            }
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 10)
    }
    
    func test_네트워크통신없이_productList데이터_요청시_올바른값이_넘어오는지() {
        // given
        let mockSession = StubURLSession()
        let promise = expectation(description: "will return productList")
        sut = API.requestList
        
        // when
        sut.getData(session: mockSession, page: 1, itemsPerPage: 10) { result in
            // then
            switch result {
            case .success(let list):
                XCTAssertEqual(list.pageNo, 1)
                XCTAssertEqual(list.itemsPerPage, 20)
                XCTAssertEqual(list.totalCount, 10)
            case .failure(_):
                XCTAssert(false, "에러 발생하면 안됨")
            }
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 10)
    }
}
