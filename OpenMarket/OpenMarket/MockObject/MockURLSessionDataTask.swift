//
//  MockURLSessionDataTask.swift
//  OpenMarket
//
//  Created by Charlotte, Hosinging on 2021/08/19.
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
