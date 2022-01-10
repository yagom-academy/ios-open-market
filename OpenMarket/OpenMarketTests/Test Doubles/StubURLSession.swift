//
//  MockURLSession.swift
//  OpenMarketTests
//
//  Created by Jun Bang on 2022/01/06.
//

import Foundation
import UIKit.NSDataAsset
@testable import OpenMarket

final class StubURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
}


final class StubURLSession: DataTaskProvidable {
    let isSuccessfulRequest: Bool
    var sessionDataTask: StubURLSessionDataTask?
    let request: StubRequest
    
    init(isSuccessfulRequest: Bool = true, mockRequest: StubRequest) {
        self.isSuccessfulRequest = isSuccessfulRequest
        self.request = mockRequest
    }
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        let successResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let failureResponse = HTTPURLResponse(url: request.url!, statusCode: 410, httpVersion: nil, headerFields: nil)
        let sessionDataTask = StubURLSessionDataTask()
        
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
