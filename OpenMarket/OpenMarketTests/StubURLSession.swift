//
//  StubURLSession.swift
//  OpenMarketTests
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import Foundation
@testable import OpenMarket

final class MockURLSession: URLSessionProtocol {
    var dummyData: DummyData?

    init(dummy: DummyData) {
        self.dummyData = dummy
    }

    func dataTask(with url: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTaskProtocol {
        return MockURLSessionDataTask(resumeCompletion: completionHandler)
    }
}
