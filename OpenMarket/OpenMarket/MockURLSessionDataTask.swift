//
//  MockURLSessionDataTask.swift
//  OpenMarketUnitTests
//
//  Created by 이윤주 on 2021/08/17.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> () = { }
    override func resume() {
        resumeDidCall()
    }
}
