//
//  MockURLSession.swift
//  URLSessionManagerTest
//
//  Created by 주디, 재재 on 2022/07/14.
//

import UIKit

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    var newResume: () -> Void = {}
    
    func resume() {
        newResume()
    }
}

final class MockURLSession: URLSessionProtocol {
    var isSuccess: Bool
    
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        var success: HTTPURLResponse?
        var failure: HTTPURLResponse?
        
        if let url = request.url {
            success = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2.0", headerFields: nil)
            failure = HTTPURLResponse(url: url, statusCode: 404, httpVersion: "2.0", headerFields: nil)
        }
        
        let mockURLSessionDataTask = MockURLSessionDataTask()
        
        if isSuccess {
            let mockData = NSDataAsset.init(name: "MockData")?.data
            mockURLSessionDataTask.newResume = {
                completionHandler(mockData, success, nil)
            }
        } else {
            mockURLSessionDataTask.newResume = {
                completionHandler(nil, failure, nil)
            }
        }
        return mockURLSessionDataTask
    }
}
