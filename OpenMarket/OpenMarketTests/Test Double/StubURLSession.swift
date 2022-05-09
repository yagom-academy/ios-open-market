//
//  StubURLSession.swift
//  OpenMarketTests
//
//  Created by dudu, safari on 2022/05/09.
//

import Foundation

@testable import OpenMarket

struct DummyData {
    var data: Data?
    
    mutating func setUp() {
        guard let path = Bundle.main.path(forResource: "products", ofType: "json") else { return }
        guard let jsonString = try? String(contentsOfFile: path) else { return }
        data = jsonString.data(using: .utf8)
    }
}

class StubURLSessionDataTask: URLSessionDataTask {
    var completion: () -> Void = {}

    override func resume() {
        completion()
    }
}


class StubURLSession: URLSessionProtocol {
    var isRequestSuccess: Bool
    var sessionDataTask: StubURLSessionDataTask?
    
    init(isRequestSuccess: Bool = true) {
        self.isRequestSuccess = isRequestSuccess
    }
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
        let successResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2", headerFields: nil)
        let failureResponse = HTTPURLResponse(url: url, statusCode: 402, httpVersion: "2", headerFields: nil)
        
        let sessionDataTask = StubURLSessionDataTask()
        var dummyData = DummyData()
        dummyData.setUp()
        
        if isRequestSuccess {
            sessionDataTask.completion = {
                completionHandler(dummyData.data, successResponse, nil)
            }
        } else {
            sessionDataTask.completion = {
                completionHandler(nil, failureResponse, nil)
            }
        }
        
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}

