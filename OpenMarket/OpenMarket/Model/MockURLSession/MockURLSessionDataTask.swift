//
//  MockURLSessionDataTask.swift
//  OpenMarket
//
//  Created by kio on 2021/06/10.
//

import Foundation

class MockURLSessionDataTask: MockURLSessionDataTask {
    override init() {}
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
}
