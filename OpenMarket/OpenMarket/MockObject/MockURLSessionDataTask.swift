//
//  MockURLSessionDataTask.swift
//  OpenMarket
//
//  Created by Theo on 2021/08/19.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {

    var resumeDidcall: () -> () = {}
    private var resumeCalled = false
    override func resume() {
        resumeCalled = true
        resumeDidcall()
    }

}
