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
        let data = "test".data(using: .utf8)!
        let url = URL(string: "testURL")!
        let responce = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let dummyData = DummyData(data: data, response: responce, error: nil)
        let session = MockSession(dummyData: dummyData)
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
        let data = "test".data(using: .utf8)!
        let url = URL(string: "testURL")!
        let responce = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        let dummyData = DummyData(data: data, response: responce, error: nil)
        let session = MockSession(dummyData: dummyData)
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
