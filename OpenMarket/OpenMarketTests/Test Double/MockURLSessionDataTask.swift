//
//  MockURLSessionDataTask.swift
//  OpenMarketTests
//
//  Created by yeha on 2022/01/06.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    override init() { }
    var resumeDidCall = { }

    override func resume() {
        resumeDidCall()
    }
}
