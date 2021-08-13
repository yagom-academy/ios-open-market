//
//  MockURLSessionDataTask.swift
//  OpenMarketTests
//
//  Created by Dasoll Park on 2021/08/11.
//

import Foundation
@testable import OpenMarket

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    var resumeDidCall: () -> Void = {}
    
    func resume() {
        resumeDidCall()
    }
}
