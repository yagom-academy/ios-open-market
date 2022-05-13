//
//  URLProductTests.swift
//  URLProductTests
//
//  Created by 김동욱 on 2022/05/12.
//

import XCTest
@testable import OpenMarket

class URLProductTests: XCTestCase {
    
    var sut: URLSessionProvider<Product>!
    
    override func setUpWithError() throws {
        sut = URLSessionProvider()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_URL이_api_products_2085_일때_fetchData_메서드를_호출하면_data의vendorId_값이_14인지() {
        //given
        let promise = expectation(description: "The vendorId value of data is 14")
        
        //when
        sut.getData(from: .detailProduct(id: 2085)) { result in
            //then
            switch result {
            case .success(let data):
                XCTAssertEqual(data.vendorId, 14)
            case .failure(_):
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }
}
