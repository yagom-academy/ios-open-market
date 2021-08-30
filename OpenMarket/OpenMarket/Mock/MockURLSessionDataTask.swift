//
//  MockURLSessionDataTask.swift
//  OpenMarketTests
//
//  Created by Dasoll Park on 2021/08/11.
//

import Foundation

struct MockURLSessionDataTask: URLSessionDataTaskProtocol {
    var resumeDidCall: () -> Void = {}
    
    func resume() {
        resumeDidCall()
    }
}
