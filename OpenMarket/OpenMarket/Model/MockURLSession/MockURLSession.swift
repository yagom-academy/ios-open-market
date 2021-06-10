//
//  MockURLSession.swift
//  OpenMarket
//
//  Created by kio on 2021/06/10.
//

import Foundation

class MockURLSession: MockURLSessionProtocol {
    var isRequestSuccess: Bool
    let sessionDataTask = MockURLSessionDataTask()
    
    init(isRequestSuccess: Bool){
        self.isRequestSuccess = isRequestSuccess
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let successResponse = HTTPURLResponse(url: JokesAPI.url,
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)
        let failureResponse = HTTPURLResponse(url: JokesAPI.url,
                                              statusCode: 402,
                                              httpVersion: "2",
                                              headerFields: nil)
        if isRequestSuccess {
            sessionDataTask.resumeDidCall = { completionHandler(JokesAPI().sampleData, successResponse, nil) }
        } else {
            sessionDataTask.resumeDidCall = { completionHandler(nil, failureResponse, nil) }
        }
        
        return sessionDataTask
    }
}
