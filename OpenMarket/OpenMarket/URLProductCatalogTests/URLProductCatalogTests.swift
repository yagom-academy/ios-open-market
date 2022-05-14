//
//  URLSessionTests.swift
//  URLSessionTests
//
//  Created by song on 2022/05/12.
//

import XCTest
@testable import OpenMarket

class URLProductCatalogTests: XCTestCase {

    var sut: URLSessionProvider<ProductList>!
    override func setUpWithError() throws {
        sut = URLSessionProvider()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
   
    func test_URL이_상품리스트_조회_일때_fetchData_메서드를_호출하면_data의offset_값이_10인지() {
        //given
        let promise = expectation(description: "The offset value of data is 10")
        
        //when
        sut.getData(from: .productList(page: 2, itemsPerPage: 10)) { result in
            //then
            switch result {
            case .success(let data):
                XCTAssertEqual(data.offset, 10)
            case .failure(_):
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
    
    func test_URL이_상품리스트_조회_일때_fetchData_메서드를_호출하면_data의offset_값이_0인지() {
        //given
        let promise = expectation(description: "The offset value of data is 10")
        
        //when
        sut.getData(from: .productList(page: 1, itemsPerPage: 11)) { result in
            //then
            switch result {
            case .success(let data):
                XCTAssertEqual(data.offset, 0)
            case .failure(_):
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
}
