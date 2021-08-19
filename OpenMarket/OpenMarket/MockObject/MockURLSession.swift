//
//  MockURLSession.swift
//  OpenMarket
//
//  Created by Theo on 2021/08/19.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    private var url: URL?
    var makedDataTask = MockURLSessionDataTask()
    
    func makedDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return makedDataTask
    }
    
}
