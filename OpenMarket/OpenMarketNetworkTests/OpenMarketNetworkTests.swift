//
//  OpenMarketNetworkTests.swift
//  OpenMarketNetworkTests
//
//  Created by James on 2021/05/31.
//

import XCTest
@testable import OpenMarket
final class OpenMarketNetworkTests: XCTestCase {
    var sut_networkManager: NetworkManageable!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut_networkManager = NetworkManager(urlSession: MockURLSession())
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut_networkManager = nil

    }
    
    func test_networkResponse_successfulResponse_receiveStatusCode200() {
        // given
        let expectation = XCTestExpectation()
        let pageNumber: Int = 1
    
        // when
        sut_networkManager.examineNetworkResponse(page: pageNumber) { result in
            
            // then
            switch result {
            case .success(let response):
                XCTAssertEqual(response.statusCode, 200)
                // then
            case .failure(let error):
                XCTFail("\(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_networkResponse_failureResponse_receiveStatusCode400() {
        // given
        sut_networkManager = NetworkManager(urlSession: MockURLSession.init(buildRequestFail: true))
        let expectation = XCTestExpectation()
        let pageNumber: Int = 1
        
        // when
        sut_networkManager.examineNetworkResponse(page: pageNumber) { result in
            
            // then
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_networkRequest_correctURL() {
        // given
        let expectation = XCTestExpectation()
        let pageNumber: Int = 1
        
        // when
        sut_networkManager.examineNetworkRequest(page: pageNumber) { result in

            // then
            switch result {
            case .success(let request):
                XCTAssertEqual(request.url, URL(string: "\(OpenMarketAPI.urlForItemList)\(pageNumber)"))
            case .failure(let errror):
                XCTFail("\(errror)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_networkRequest_correctHTTPMethod_GET() {
        //given
        let expectation = XCTestExpectation()
        let pageNumber: Int = 1
        
        //when
        sut_networkManager.examineNetworkRequest(page: pageNumber) { result in
            switch result {
            case .success(let request):
                XCTAssertEqual(request.httpMethod, HTTPMethods.get.rawValue)
            case .failure(let error):
                XCTFail("\(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
