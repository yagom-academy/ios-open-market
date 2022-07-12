//
//  MockURLSession.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/12.
//

import Foundation
import UIKit


class MockURLSessionDataTask: URLSessionDataTask {
    var newResume: () -> Void = {}
    
    override func resume() {
        newResume
    }
}

class MockURLSession: URLSessionProtocol {
    var isSuccess: Bool
    
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
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
