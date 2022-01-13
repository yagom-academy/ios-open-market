//
//  NetworkTests.swift
//  OpenMarketTests
//
//  Created by Ari on 2022/01/05.
//

import XCTest
@testable import OpenMarket

class NetworkTests: XCTestCase {
    var sutURL: URL?
    var sutData: Data?
    var sutRequest: URLRequest?
    var sutSession: URLSession?
    var sutNetwork: Network?
        
    override func setUpWithError() throws {
        sutURL = URL(string: "testURL")
        sutData = Data()
        sutRequest = URLRequest(url: sutURL!)
        sutSession = MockSession.session
        sutNetwork = Network(session: sutSession!)
    }
    
    override func tearDownWithError() throws {
        sutRequest = nil
        sutSession = nil
        sutNetwork = nil
    }

    func test_Success() {
        // given
        let response = HTTPURLResponse(url: sutURL!, statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockURLs = [sutURL: (nil, sutData, response)]
        let expectation = XCTestExpectation(description: "네트워크 실행")
        
        // when
        sutNetwork!.execute(request: sutRequest!) { result in
            
            // then
            switch result {
            case .success(let sampleData):
                XCTAssertEqual(sampleData, self.sutData)
            case .failure:
                XCTFail()
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_Failure() {
        // given
        let response = HTTPURLResponse(url: sutURL!, statusCode: 404, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockURLs = [sutURL: (nil, sutData, response)]
        let expectation = XCTestExpectation(description: "네트워크 실행")
        
        // when
        sutNetwork!.execute(request: sutRequest!) { result in
            
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
