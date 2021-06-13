//
//  MockURLSession.swift
//  OpenMarketNetworkTests
//
//  Created by James on 2021/06/01.
//

import Foundation
@testable import OpenMarket
final class MockURLSession: URLSessionProtocol {
    private let pageNumber: Int = 1
    private var buildRequestFail: Bool = false

    
    init(buildRequestFail: Bool = false) {
        self.buildRequestFail = buildRequestFail
    }
    
    var sessionDataTask: MockURLSessionDataTask?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        guard let url = URL(string: "\(OpenMarketAPI.urlForItemList)\(pageNumber)") else {
            return URLSessionDataTask()
            
        }
        let successfulResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2", headerFields: nil)
        let failureResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: "2", headerFields: nil)
        let sessionDataTask = MockURLSessionDataTask()
        
        sessionDataTask.resumeDidCall = {
            if self.buildRequestFail {
                completionHandler(nil, failureResponse, nil)
            } else {
                completionHandler(nil, successfulResponse, nil)
            }
        }
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}
