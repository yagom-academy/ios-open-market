//
//  MockURLProtocol.swift
//  OpenMarketTests
//
//  Created by Hailey, Ryan on 2021/05/18.
//

import XCTest
@testable import OpenMarket

final class MockURLProtocol: URLProtocol {
    static var loadingHandler: ((URLRequest) -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.loadingHandler else {
            XCTFail("Loading handler is not set.")
            return
        }
        let (response, data) = handler(request)
        
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
