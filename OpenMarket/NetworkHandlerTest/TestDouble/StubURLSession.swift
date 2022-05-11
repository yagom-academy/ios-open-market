//
//  MockURLSession.swift
//  NetworkHandlerTest
//
//  Created by 두기, minseong on 2022/05/11.
//

import Foundation
@testable import OpenMarket

struct DummyData {
    var data: Data?
    var response: URLResponse?
    var error: Error?
}

final class StubURLSessionDataTask: URLSessionDataTask {
    var fakeResume: () -> Void = {}
    
    override func resume() {
        fakeResume()
    }
}

struct StubURLSession: URLSessionProtocol {
    let dummyData: DummyData
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let sessionDataTask = StubURLSessionDataTask()
        
        sessionDataTask.fakeResume = {
            completionHandler(dummyData.data, dummyData.response, dummyData.error)
        }
        
        return sessionDataTask
    }
}
