//
//  NetworkUnitTest.swift
//  NetworkUnitTest
//
//  Created by Baemini on 2022/11/15.
//

import XCTest
@testable import OpenMarket

class NetworkUnitTest: XCTestCase {
    var sut: NetworkManager<ProductListResponse>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkManager<ProductListResponse>()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_MockingNetworking으로_더미데이터를_잘받아오는가() {
        //given
        let promise = expectation(description: "Response is Success")
        let api = OpenMarketAPI.productsList(pageNumber: 1, rowCount: 1)
        let stubURLSession = StubURLSession<ProductListResponse>(isSuccess: true)
        
        //when
        sut?.session = stubURLSession
        sut?.fetchData(endPoint: api) { _ in
            XCTAssertEqual(self.sut?.testData, ProductListResponse.mockData)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 3)
    }
}
