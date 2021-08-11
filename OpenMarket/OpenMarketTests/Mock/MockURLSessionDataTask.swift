//
//  MockURLSessionDataTask.swift
//  OpenMarketTests
//
//  Created by Dasoll Park on 2021/08/11.
//

import Foundation
@testable import OpenMarket

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let resumeDidCall: () -> Void
    
    init(resumeDidCall: @escaping () -> Void) {
        self.resumeDidCall = resumeDidCall
    }
    
    func resume() {
        resumeDidCall()
    }
}
