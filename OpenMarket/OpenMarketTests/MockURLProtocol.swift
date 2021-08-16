//
//  MockURLProtocol.swift
//  OpenMarketTests
//
//  Created by Kim Do hyung on 2021/08/16.
//

import Foundation
@testable import OpenMarket

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    class override func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    class override func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        do {
            guard let handler = MockURLProtocol.requestHandler else {
                throw NetworkError.invalidHandler
            } 
            
            let (response, data) = try handler(request)
            
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            } else {
                throw NetworkError.invalidData
            }
            
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        
    }
}
