//
//  MockURLSession.swift
//  OpenMarketTests
//
//  Created by Jun Bang on 2022/01/06.
//

import Foundation
import UIKit.NSDataAsset
@testable import OpenMarket

final class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
}


final class MockURLSession: DataTaskProvidable {
    var isSuccessfulRequest: Bool
    var sessionDataTask: MockURLSessionDataTask?
    var request: MockRequest
    
    init(isSuccessfulRequest: Bool = true, mockRequest: MockRequest) {
        self.isSuccessfulRequest = isSuccessfulRequest
        self.request = mockRequest
    }
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        let successResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let failureResponse = HTTPURLResponse(url: request.url!, statusCode: 410, httpVersion: nil, headerFields: nil)
        let sessionDataTask = MockURLSessionDataTask()
        
        sessionDataTask.resumeDidCall = {
            if self.isSuccessfulRequest {
                completionHandler(self.request.data, successResponse, nil)
                
            } else {
                completionHandler(nil, failureResponse, nil)
            }
        }
        
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}
