//
//  MockURLSessionDataTask.swift
//  OpenMarketTests
//
//  Created by tae hoon park on 2021/09/01.
//

import Foundation
@testable import OpenMarket

class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
}
