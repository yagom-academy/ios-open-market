//
//  NetworkManagerTests.swift
//  OpenMarketTests
//
//  Created by 이호영 on 2022/01/05.
//

import XCTest
@testable import OpenMarket

class NetworkManagerTests: XCTestCase {
    var sutNetworkManager: NetworkManager?
    var stubProducts = NSDataAsset(name: "products")!.data
    var stubProduct = NSDataAsset(name: "product")!.data
    
    override func setUpWithError() throws {
        let session = MockSession.session
        let netWork = Network(session: session)
        let parser = StubParser()
        sutNetworkManager = NetworkManager(network: netWork, parser: parser)
    }
    
    override func tearDownWithError() throws {
        sutNetworkManager = nil
    }
    
    func test_Fetch_Success() {
        // given
        let url = URL(string: "testURL")!
        let data = self.stubProducts
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockURLs = [url: (nil, data, response)]
        
        let request = URLRequest(url: url)
        let decodingtype = Products.self
        let expectation = XCTestExpectation(description: "네트워크 실행")
        
        sutNetworkManager?.fetch(request: request, decodingType: decodingtype) { result in
        
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
    
    func test_Fetch_Decode_failure() {
        // given
        let url = URL(string: "testURL")!
        let data = self.stubProducts
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockURLs = [url: (nil, data, response)]
        
        let request = URLRequest(url: url)
        let decodingtype = StubProduct.self
        let expectation = XCTestExpectation(description: "네트워크 실행")
        
        //when
        sutNetworkManager?.fetch(request: request, decodingType: decodingtype) { result in
        
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
    
    func test_Fetch_Network_failure() {
        // given
        let url = URL(string: "testURL")!
        let data = self.stubProducts
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        MockURLProtocol.mockURLs = [url: (nil, data, response)]
        
        let request = URLRequest(url: url)
        let decodingtype = Products.self
        let expectation = XCTestExpectation(description: "네트워크 실행")
        
        //when
        sutNetworkManager?.fetch(request: request, decodingType: decodingtype) { result in
        
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
    
    func test_request_상품리스트조회() {
        //given
        let url = NetworkConstant.products(page: 1, itemsPerPage: 10).url
        
        //when
        let result = sutNetworkManager?.request(page: 1, itemsPerPage: 10)
        
        //then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.url, url)
        XCTAssertEqual(result?.httpMethod, NetworkConstant.HTTPMethod.get.rawValue)
    }
}
