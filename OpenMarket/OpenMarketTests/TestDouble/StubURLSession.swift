//  StubURLSession.swift
//  OpenMarketTests
//  Created by SummerCat & Bella on 2022/11/21.

import Foundation
@testable import OpenMarket

class StubURLSession: URLSessionable {
    let data: Data
    let response: URLResponse
    let error: Error?

    init(data: Data, response: URLResponse, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> URLSessionDataTask {
        completionHandler(data, response, error)
        
        let task = MockURLSessionDataTask()
        return task
    }
    
}
