//
//  MockURLSessionDataTask.swift
//  OpenMarketTests
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import Foundation
@testable import OpenMarket

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    var dummyData: DummyData?
    
    init(resumeCompletion: @escaping DataTaskCompletionHandler) {
        self.dummyData?.completionHandler = resumeCompletion
    }

    func resume() {
        dummyData?.resumeCompletion()
    }
}
