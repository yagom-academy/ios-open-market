//
//  MockURLSession.swift
//  OpenMarketTests
//
//  Created by 이윤주 on 2021/09/03.
//

import Foundation
@testable import OpenMarket

struct MockURLSession: URLSessionProtocol {
    private let mockURLSessionDataTask = MockURLSessionDataTask()
    var isRequestSuccess: Bool
    init(isSuccess: Bool) {
        self.isRequestSuccess = isSuccess
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let successResponse = HTTPURLResponse(url: request.url!,
                                     statusCode: 200,
                                     httpVersion: "2",
                                     headerFields: nil)

        let failureResponse = HTTPURLResponse(url: request.url!,
                                    statusCode: 400,
                                    httpVersion: "2",
                                    headerFields: nil)

        let path = Bundle(for: OpenMarketTests.self).path(forResource: "Item", ofType: "json")
        let jsonData = try? String(contentsOfFile: path!).data(using: .utf8)

        if self.isRequestSuccess == true {
            mockURLSessionDataTask.resumeDidCall = { completionHandler(jsonData, successResponse, nil) }
        } else {
            mockURLSessionDataTask.resumeDidCall = { completionHandler(nil, failureResponse, nil) }
        }

        return mockURLSessionDataTask
    }
}
