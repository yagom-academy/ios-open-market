//
//  MockURLSessionDataTask.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/31.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    override init() {}
    var resumeDidCall: () -> Void = {}

    override func resume() {
        resumeDidCall()
    }
}
