//
//  MockURLSessionDataTask.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 16/11/2022.
//

import Foundation

protocol MockURLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: MockURLSessionDataTaskProtocol { }

final class MockURLSessionDataTask: MockURLSessionDataTaskProtocol {
    var resumeDidCall: () -> Void = {}

    func resume() {
        resumeDidCall()
    }
}
