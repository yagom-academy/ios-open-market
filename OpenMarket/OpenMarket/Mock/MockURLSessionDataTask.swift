//
//  MockURLSessionDataTask.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/18.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
}
