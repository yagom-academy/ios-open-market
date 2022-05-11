//
//  StubURLSession.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/10.
//

import Foundation

struct DummyData {
    let data: Data?
    let response: HTTPURLResponse?
    let error: Error?
    var completionHandler: DataTaskCompletionHandler?
    
    func completion() {
        completionHandler?(data, response, error)
    }
}

final class StubURLSessionDataTask: URLSessionDataTask {
    var dummyData: DummyData?
    
    init(dummy: DummyData?, completionHandler: DataTaskCompletionHandler?) {
        self.dummyData = dummy
        self.dummyData?.completionHandler = completionHandler
    }
    
    override func resume() {
        dummyData?.completion()
    }
}

final class StubURLSession: URLSessionProtocol {
    var dummyData: DummyData?
    
    init(dummy: DummyData) {
        self.dummyData = dummy
    }
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {

        return StubURLSessionDataTask(dummy: dummyData, completionHandler: completionHandler)
    }
}
