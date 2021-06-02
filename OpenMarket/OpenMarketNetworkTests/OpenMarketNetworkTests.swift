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
    
    func test_getItemList_successfulResponse() {
        // given
        let expectation = XCTestExpectation()
        let pageNumber = 1
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
    
    func test_ItemList_url() {
        // given
        let expectation = XCTestExpectation()
        let pageNumber = 1
        // when
        sut_networkManager.examineNetworkResponse(page: pageNumber) { result in
            
            // then
            switch result {
            case .success(let response):
                XCTAssertEqual(response.url, URL(string: "\(OpenMarketAPI.connection.urlForItemList)\(pageNumber)"))
                // then
            case .failure(let error):
                XCTFail("\(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_ItemList_httpMethod_get() {
        // given
        let expectation = XCTestExpectation()
        let pageNumber = 1
        // when
        sut_networkManager.examineNetworkRequest(page: pageNumber) { result in
            
            // then
            switch result {
            case .success(let request):
                XCTAssertEqual(request.httpMethod, HTTPMethods.get.rawValue)
                // then
            case .failure(let error):
                XCTFail("\(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_getItemList_failureResponse() {
        // given
        sut_networkManager = NetworkManager(urlSession: MockURLSession.init(buildRequestFail: true))
        let expectation = XCTestExpectation()
        
        // when
        sut_networkManager.examineNetworkResponse(page: 1) { result in
            
            // then
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.description, "Network is not responding")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

}
