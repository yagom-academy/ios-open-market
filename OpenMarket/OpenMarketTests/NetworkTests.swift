//
//  NetworkTests.swift
//  NetworkTests
//
//  Created by dudu, safari on 2022/05/09.
//

import XCTest

@testable import OpenMarket

class NetworkTests: XCTestCase {
    
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}
    
    func test_네트워크에_서버상태요청시_OK가_넘어오는지() {
        // given
        let promise = expectation(description: "will return OK message")
        let sut = API<String>.serverState
        
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
        let sut = API<ProductList>.requestList(page: 1, itemsPerPage: 10)
        
        // when
        sut.request { result in
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
        let sut = API<ProductDetail>.requestProduct(id: 2072)
 
        // when
        sut.request { result in
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
    
    func test_네트워크통신없이_요청시_성공하는_경우() {
        // given
        let mockSession = MockURLSession()
        let promise = expectation(description: "will return productList")
        let sut = API<ProductList>.requestList(page: 1, itemsPerPage: 10)
        
        // when
        sut.request(session: mockSession) { result in
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
    
    func test_네트워크통신없이_요청시_실패하는_경우() {
        // given
        let mockSession = MockURLSession(isRequestSuccess: false)
        let promise = expectation(description: "will return productList")
        let sut = API<ProductList>.requestList(page: 1, itemsPerPage: 10)
        
        // when
        sut.request(session: mockSession) { result in
            // then
            switch result {
            case .success(_):
                XCTAssert(false, "성공하면 안됨")
            case .failure(_):
                XCTAssert(true, "테스트 성공")
            }
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 10)
    }
}
