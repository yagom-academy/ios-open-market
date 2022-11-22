//  MockURLSessionDataTask.swift
//  OpenMarketTests
//  Created by SummerCat & Bella on 2022/11/21.

import Foundation
@testable import OpenMarket

class MockURLSessionDataTask: URLSessionDataTask {
    var mockHandler: () -> Void = { }
    
    override func resume() {
        mockHandler()
    }
}
