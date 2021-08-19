//
//  MockURLSession.swift
//  OpenMarket
//
//  Created by Theo on 2021/08/19.
//

import Foundation

class MockURLSession: URLSessionProtocol, Equatable {
    static func == (lhs: MockURLSession, rhs: MockURLSession) -> Bool {
        return true
    }
    
    private (set) var mockUrl: URL?
    var makedDataTask = MockURLSessionDataTask()
    
    func makedDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        mockUrl = url
        return makedDataTask
    }
    
}
