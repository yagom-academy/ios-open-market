//
//  MockURLProtocol.swift
//  HTTPManagerTests
//
//  Created by papri, Tiana on 13/05/2022.
//

import XCTest
import Foundation

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func stopLoading() { }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
}
