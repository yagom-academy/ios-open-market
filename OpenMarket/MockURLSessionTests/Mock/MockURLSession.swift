//
//  OpenMarket - MockURLSession.swift
//  Created by Zhilly, Dragon. 22/11/16
//  Copyright © yagom. All rights reserved.
//

import Foundation

final class MockURLSession: URLSessionProtocol {
    private var isRequestSuccess: Bool
    private var sessionDataTask: MockURLSessionDataTask?
    
    init(isRequestSuccess: Bool = true) {
        self.isRequestSuccess = isRequestSuccess
    }
    
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) ->
    URLSessionDataTask {
        let successResponse: HTTPURLResponse? = HTTPURLResponse(url: request.url!,
                                                                statusCode: 200,
                                                                httpVersion: "2",
                                                                headerFields: nil)
        let failureResponse: HTTPURLResponse? = HTTPURLResponse(url: request.url!,
                                                                statusCode: 402,
                                                                httpVersion: "2",
                                                                headerFields: nil)
        let sessionDataTask: MockURLSessionDataTask = MockURLSessionDataTask()
        
        if isRequestSuccess {
            sessionDataTask.resumeDidCall = {
                completionHandler(MockData.data, successResponse, nil)
            }
        } else {
            sessionDataTask.resumeDidCall = {
                completionHandler(nil, failureResponse, nil)
            }
        }
        
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}
