//
//  NetworkManagerTests.swift
//  OpenMarketTests
//
//  Created by 이호영 on 2022/01/05.
//

import XCTest
@testable import OpenMarket

class NetworkManagerTests: XCTestCase {

    
    func test_Fetch_Success() {
        // given
        let data = "test".data(using: .utf8)!
        let url = URL(string: "testURL")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let dummydata = DummyData(data: data, response: response, error: nil)
        let session = MockSession(dummyData: dummydata)
        let netWork = Network(session: session)
        let parser = MockParser()
        let networkManager = NetworkManager(network: netWork, parser: parser)
        
        let request = URLRequest(url: url)
        let decodingtype = Products.self
        let expectation = XCTestExpectation(description: "네트워크 실행")
        
        networkManager.fetch(request: request, decodingType: decodingtype) { result in
        
            // then
            switch result {
            case .success:
                XCTAssert(true)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func test_Fetch_failure() {
        // given
        let url = URL(string: "testURL")!
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        let dummydata = DummyData(data: nil, response: response, error: nil)
        let session = MockSession(dummyData: dummydata)
        let netWork = Network(session: session)
        let parser = MockParser()
        let networkManager = NetworkManager(network: netWork, parser: parser)
        
        let request = URLRequest(url: url)
        let decodingtype = Image.self
        let expectation = XCTestExpectation(description: "네트워크 실행")
        
        networkManager.fetch(request: request, decodingType: decodingtype) { result in
        
            // then
            switch result {
            case .success:
                XCTFail()
            case .failure:
                XCTAssert(true)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
