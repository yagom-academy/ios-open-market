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
    
    init(dummy: DummyData?, resumeCompletion: @escaping DataTaskCompletionHandler) {
        self.dummyData = dummy
        self.dummyData?.completionHandler = resumeCompletion
    }

    func resume() {
        dummyData?.resumeCompletion()
    }
}
