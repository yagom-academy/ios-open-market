//
//  MockURLSession.swift
//  OpenMarket
//
//  Created by marisol on 2022/05/10.
//

import Foundation

struct MockData {
    let data = Data()
}

final class MockURLSessionDataTask: URLSessionDataTask {
    var completion: () -> Void = {}
    
    override func resume() {
        completion()
    }
}

final class MockURLSession: URLSessionProtocol {
    var isRequestSuccess: Bool
    var sessionDataTask: MockURLSessionDataTask?
    
    init(isRequestSucceses: Bool = true) {
        self.isRequestSuccess = isRequestSucceses
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let successResponse = HTTPURLResponse(url: url,
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)
        let failureResponse = HTTPURLResponse(url: url,
                                              statusCode: 404,
                                              httpVersion: "2",
                                              headerFields: nil)
        let sessionDataTask = MockURLSessionDataTask()
        
        if isRequestSuccess {
            sessionDataTask.completion = {
                completionHandler(MockData().data, successResponse, nil)
            }
        } else {
            sessionDataTask.completion = {
                completionHandler(nil, failureResponse, nil)
            }
        }

        return sessionDataTask
    }
}
