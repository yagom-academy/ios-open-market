//
//  MockURLSession.swift
//  OpenMarketTests
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import Foundation
@testable import OpenMarket

final class MockURLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping DataTaskCompletionHandler
    ) -> URLSessionDataTaskProtocol {
        return MockURLSessionDataTask(dummy: dummyData, resumeCompletion: completionHandler)
    }
    
    var dummyData: DummyData?

    init(dummy: DummyData) {
        self.dummyData = dummy
    }

    func dataTask(with url: URL,
                  completionHandler: @escaping DataTaskCompletionHandler
    ) -> URLSessionDataTaskProtocol {
        return MockURLSessionDataTask(dummy: dummyData, resumeCompletion: completionHandler)
    }
}
