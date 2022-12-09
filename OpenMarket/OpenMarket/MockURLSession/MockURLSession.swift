//
//  MockURLSession.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/16.
//

import Foundation

final class MockURLSession: URLSessionProtocol {
    private var isRequestFail: Bool
    private var sessionDataTask: MockURLSessionDataTask?
    
    init(isRequestFail: Bool = false) {
        self.isRequestFail = isRequestFail
    }
    
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?,
                                                URLResponse?,
                                                Error?) -> Void) -> MockURLSessionDataTaskProtocol {
        guard let url = request.url else {
            return MockURLSessionDataTask()
        }
        
        let successResponse = MockHTTPURLResponse(url: url,
                                                  statusCode: 200,
                                                  httpVersion: "2",
                                                  headerFields: nil)
        
        let failureResponse = MockHTTPURLResponse(url: url,
                                                  statusCode: 410,
                                                  httpVersion: "2",
                                                  headerFields: nil)
        
        let sessionDataTask = MockURLSessionDataTask()
        
        sessionDataTask.resumeDidCall = {
            if self.isRequestFail {
                completionHandler(nil, failureResponse, nil)
            } else {
                completionHandler(SampleData.sampleData, successResponse, nil)
            }
        }
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}
