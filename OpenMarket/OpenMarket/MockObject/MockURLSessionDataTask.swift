//
//  MockURLSessionDataTask.swift
//  OpenMarket
//
//  Created by Theo on 2021/08/19.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTaskProtocol {

    var resumeDidcall: () -> () = {}
    private var resumeCalled = false
    func resume() {
        resumeCalled = true
        resumeDidcall()
    }

}
