//
//  MockURLSessionDataTask.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/12.
//

import Foundation

final class MockURLSessionDataTask: URLSessionDataTask {
    private let resumeHandler: () -> Void

    init(resumeHandler: @escaping () -> Void) {
        self.resumeHandler = resumeHandler
    }

    override func resume() {
        resumeHandler()
    }
}
