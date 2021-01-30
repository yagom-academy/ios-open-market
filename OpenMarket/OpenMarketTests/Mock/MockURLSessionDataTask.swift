//
//  MockURLSessionDataTask.swift
//  OpenMarketTests
//
//  Created by Kyungmin Lee on 2021/01/28.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = {}
    
    override init() { }
    
    override func resume() {
        resumeDidCall()
    }
}
