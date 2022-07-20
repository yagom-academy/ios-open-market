//
//  MockURLSessionDataTask.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/12.
//

import Foundation

final class MockURLSessionDataTask: URLSessionDataTask {
    var resumeHandler: () -> Void = {}

    override func resume() {
        resumeHandler()
    }
}
