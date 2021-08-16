//
//  MockURLSession.swift
//  OpenMarketTests
//
//  Created by Dasoll Park on 2021/08/13.
//

import UIKit
@testable import OpenMarket

struct MockURLSession: URLSessionProtocol {
    func dataTaskWithRequest(with request: URLRequest,
                             completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTaskProtocol
    {
        let url = request.url ?? URL(string: "")!
        let successResponse = HTTPURLResponse(url: url,
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)
        let failureResponse = HTTPURLResponse(url: url,
                                              statusCode: 404,
                                              httpVersion: "2",
                                              headerFields: nil)
        
        var sessionDataTask = MockURLSessionDataTask()
        let data = MockURL.obtainData(of: url)
        let response = (data == nil) ? failureResponse : successResponse
        sessionDataTask.resumeDidCall = {
            completionHandler(data, response, nil)
        }
        return sessionDataTask
    }
}
