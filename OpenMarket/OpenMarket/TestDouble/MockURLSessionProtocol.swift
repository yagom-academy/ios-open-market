//
//  MockURLSessionProtocol.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

import Foundation
import UIKit.NSDataAsset

protocol URLSessionProtocol {
    typealias completionHandler = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest,
                      completionHandler: @escaping completionHandler) -> MockURLSessionDataTask
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    var resumeDidCall: () -> Void = {}

    func resume() {
        resumeDidCall()
    }
}

class MockURLSession: URLSessionProtocol {
    var sessionDataTask: MockURLSessionDataTask?

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping completionHandler) -> MockURLSessionDataTask
    {
        let sucessResponse = HTTPURLResponse(url: request.url!,
                                             statusCode: 200,
                                             httpVersion: "2",
                                             headerFields: nil)
        let sessionDataTask = MockURLSessionDataTask()
        let data = NSDataAsset(name: "MockData")
            sessionDataTask.resumeDidCall = {
                completionHandler(data?.data, sucessResponse, nil)
            }
        self.sessionDataTask = sessionDataTask
        
        return sessionDataTask
    }
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
