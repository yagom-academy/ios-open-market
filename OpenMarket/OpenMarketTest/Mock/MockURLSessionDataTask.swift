//
//  MockURLSessionDataTask.swift
//  OpenMarketTest
//
//  Created by 김찬우 on 2021/06/08.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    override init() {}

    var resumeDidCall = {}

    override func resume() {
        resumeDidCall()
    }
}
