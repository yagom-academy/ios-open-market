//
//  MockURLSessionDataTask.swift
//  OpenMarketTests
//
//  Created by 이윤주 on 2021/09/03.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> () = {}
    override func resume() {
        resumeDidCall()
    }
}
