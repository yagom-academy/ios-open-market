//
//  StubURLSession.swift
//  OpenMarket
//
//  Created by papri, Tiana on 11/05/2022.
//

import Foundation

struct DummyData {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)? = nil
    
    func completion() {
        completionHandler?(data, response, error)
    }
}

final class StubURLSession: URLSessionProtocol {
    var dummyData: DummyData?
    
    init(dummyData: DummyData) {
        self.dummyData = dummyData
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return StubURLSessionDataTask(dummyData: dummyData, completionHandler: completionHandler)
    }
}

final class StubURLSessionDataTask: URLSessionDataTask {
    var dummyData: DummyData?
    
    init(dummyData: DummyData?, completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) {
        self.dummyData = dummyData
        self.dummyData?.completionHandler = completionHandler
    }
    
    override func resume() {
        dummyData?.completion()
    }
}
