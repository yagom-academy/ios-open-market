//
//  MockURLSession.swift
//  OpenMarketUnitTests
//
//  Created by 이윤주 on 2021/08/17.
//

import Foundation

@testable import OpenMarket

class MockURLSession: URLSessionProtocol {
    let mockURLSessionDataTask = MockURLSessionDataTask()
    var isSuccess: Bool = true
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let success: HTTPURLResponse = .init(url: request.url!,
                                             statusCode: 200,
                                             httpVersion: nil,
                                             headerFields: nil)!
        let failure: HTTPURLResponse = .init(url: request.url!,
                                             statusCode: 400,
                                             httpVersion: nil,
                                             headerFields: nil)!

        mockURLSessionDataTask.resumeDidCall = { completionHandler(nil, self.isSuccess ? success : failure, nil)}
        return mockURLSessionDataTask
    }
}
