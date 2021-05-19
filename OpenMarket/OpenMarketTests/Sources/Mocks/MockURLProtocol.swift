//
//  MockURLProtocol.swift
//  OpenMarketTests
//
//  Created by 천수현 on 2021/05/19.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) -> (HTTPURLResponse?, Data?, Error?))?
    
    class override func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    class override func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError()
        }
        
        let (response, data, error) = handler(request)
        
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        if let response = response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {

    }
}
