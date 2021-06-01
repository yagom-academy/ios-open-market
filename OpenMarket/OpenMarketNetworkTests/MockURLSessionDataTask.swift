//
//  MockURLSessionDataTask.swift
//  OpenMarketNetworkTests
//
//  Created by James on 2021/06/01.
//

import Foundation

final class MockURLSessionDataTask: URLSessionDataTask {
    override init() { }
    var resumeDidCall: () -> Void = { }
    
    override func resume() {
        resumeDidCall()
    }
}
