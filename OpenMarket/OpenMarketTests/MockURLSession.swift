//
//  MockURLSession.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/05/17.
//

import UIKit
@testable import OpenMarket

class MockURLSession: URLSessionProtocol {
    
    var makeRequestFail: Bool
    var sessionDataTask: MockURLSessionDataTask?
    
    init(makeRequestFail: Bool = false) {
        self.makeRequestFail = makeRequestFail
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        let successResponse = HTTPURLResponse(url: OpenMarketURL.viewItemList(1).url!,
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)
        
        let failureResponse = HTTPURLResponse(url: OpenMarketURL.viewItemList(1).url!,
                                              statusCode: 404,
                                              httpVersion: "2",
                                              headerFields: nil)
        
        let sessionDataTask = MockURLSessionDataTask()
        
        sessionDataTask.resumeDidCall = {
            if self.makeRequestFail {
                completionHandler(nil, failureResponse, nil)
            } else {
                guard let data: Data = NSDataAsset(name: "items")?.data else { return }
                completionHandler(data, successResponse, nil)
            }
        }
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    override init() { }
    
    var resumeDidCall: () -> Void = { }
    
    override func resume() {
        resumeDidCall()
    }
}
