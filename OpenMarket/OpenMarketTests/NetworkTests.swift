//
//  NetworkTests.swift
//  OpenMarketTests
//
//  Created by Ari on 2022/01/05.
//

import XCTest
@testable import OpenMarket

class NetworkTests: XCTestCase {
    
    func test_Success() {
        // given
        let url = URL(string: "testURL")!
        let data = Data()
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockURLs = [url: (nil, data, response)]
        let session = MockSession.session

        let network = Network(session: session)
        let request = URLRequest(url: url)
        let expectation = XCTestExpectation(description: "네트워크 실행")
        
        // when
        network.execute(request: request) { result in
            
            // then
            switch result {
            case .success(let sampleData):
                XCTAssertEqual(sampleData, data)
            case .failure:
                XCTFail()
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_Failure() {
        // given
        let url = URL(string: "testURL")!
        let data = Data()
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockURLs = [url: (nil, data, response)]
        let session = MockSession.session
        
        let network = Network(session: session)
        let request = URLRequest(url: url)
        let expectation = XCTestExpectation(description: "네트워크 실행")
        
        // when
        network.execute(request: request) { result in
            
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
