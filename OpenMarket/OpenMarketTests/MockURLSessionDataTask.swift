//
//  MockURLSessionDataTask.swift
//  OpenMarket
//
//  Created by kio on 2021/06/10.
//
import XCTest
@testable import OpenMarket

class MockURLSessionDataTask: URLSessionDataTask {
    override init() {}
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
}
