//
//  OpenMarket - MockURLSession.swift
//  Created by Zhilly, Dragon. 22/11/16
//  Copyright © yagom. All rights reserved.
//

import Foundation

struct MockData {
    let data: Data = Data()
}

class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = {}

    override func resume() {
        resumeDidCall
    }
}

class MockURLSession: URLSessionProtocol {
    var isRequestSuccess: Bool
    var sessionDataTask: MockURLSessionDataTask?

    init(isRequestSuccess: Bool = true) {
        self.isRequestSuccess = isRequestSuccess
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

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
                completionHandler(MockData().data, successResponse, nil)
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
