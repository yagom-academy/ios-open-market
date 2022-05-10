//
//  NetworkTests.swift
//  NetworkTests
//
//  Created by dudu, safari on 2022/05/09.
//

import XCTest

@testable import OpenMarket

class NetworkTests: XCTestCase {
    let mockSession = StubURLSession()
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
        
        // then
        wait(for: [promise], timeout: 10)
    }
}
