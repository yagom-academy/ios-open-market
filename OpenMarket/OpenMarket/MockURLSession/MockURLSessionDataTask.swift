//
//  MockURLSessionDataTask.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 16/11/2022.
//

import Foundation

final class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = {}

    override func resume() {
        resumeDidCall()
    }
}
