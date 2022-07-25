//
//  MockURLSessionDataTask.swift
//  OpenMarket
//
//  Created by Kiwi, Hugh on 2022/07/13.
//

import Foundation

final class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = { }
    
    override func resume() {
        resumeDidCall()
    }
}
