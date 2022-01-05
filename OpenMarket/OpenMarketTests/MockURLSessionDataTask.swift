//
//  MockURLSessionDataTask.swift
//  OpenMarketTests
//
//  Created by Ari on 2022/01/05.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    var dummyData: DummyData?

    init(dummy: DummyData?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void?) {
        self.dummyData = dummy
        self.dummyData?.completionHandler = completionHandler
    }

    override func resume() {
        dummyData?.completion()
    }
}
