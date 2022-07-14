//
//  DummyData.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

import Foundation
typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

struct DummyData {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    var completionHandler: DataTaskCompletionHandler? = nil

    func completion() {
        completionHandler?(data, response, error)
    }
}

class StubURLSession: URLSessionProtocol {
    var dummyData: DummyData?

    init(dummy: DummyData) {
        self.dummyData = dummy
    }
    
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTaskProtocol {

        return StubURLSessionDataTask(dummy: dummyData, completionHandler: completionHandler)
    }
}

class StubURLSessionDataTask: URLSessionDataTaskProtocol {
    var dummyData: DummyData?

    init(dummy: DummyData?, completionHandler: DataTaskCompletionHandler?) {
        self.dummyData = dummy
        self.dummyData?.completionHandler = completionHandler
    }

    func resume() {
        dummyData?.completion()
    }
}
