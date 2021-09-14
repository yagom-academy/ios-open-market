//
//  MockURLSessionDataTask.swift
//  OpenMarket
//
//  Created by 이예원 on 2021/09/06.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidcall: () -> Void = {}
    
    override func resume() {
        resumeDidcall()
    }
}
