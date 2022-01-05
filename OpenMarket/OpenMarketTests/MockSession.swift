//
//  MockNetwork.swift
//  OpenMarketTests
//
//  Created by Ari on 2022/01/05.
//

import Foundation
@testable import OpenMarket

struct DummyData {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void?)? = nil

    func completion() {
        completionHandler?(data, response, error)
    }
}

class MockSession: Sessionable {
    var dummyData: DummyData?
    
    init(dummyData: DummyData) {
        self.dummyData = dummyData
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask(dummy: dummyData, completionHandler: completionHandler)
    }
}
