//
//  MockURLSession.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/10.
//

import Foundation
import UIKit

class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
}

class MockURLSession: URLSessionProtocol {
    var sessionDataTask: MockURLSessionDataTask?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let sessionDataTask = MockURLSessionDataTask()
        guard let url = request.url else {
            return sessionDataTask
        }
        let successResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2", headerFields: nil)
        sessionDataTask.resumeDidCall = {
            completionHandler(NSDataAsset(name: "products", bundle: .main)?.data, successResponse, nil)
        }
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}
