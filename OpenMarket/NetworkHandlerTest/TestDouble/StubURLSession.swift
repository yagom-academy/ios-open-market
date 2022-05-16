//
//  MockURLSession.swift
//  NetworkHandlerTest
//
//  Created by 두기, minseong on 2022/05/11.
//

import Foundation
@testable import OpenMarket

final class StubURLSessionDataTask: URLSessionDataTask {
    var fakeResume: () -> Void = {}
    
    override func resume() {
        fakeResume()
    }
}

struct StubURLSession: URLSessionProtocol {
    private let dummyData: ResponseResult
    
    init(dummyData: ResponseResult) {
        self.dummyData = dummyData
    }
    
    private func fakeDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let sessionDataTask = StubURLSessionDataTask()
        
        sessionDataTask.fakeResume = {
            completionHandler(dummyData.data, dummyData.response, dummyData.error)
        }
        
        return sessionDataTask
    }
    
    func receiveResponse(request: URLRequest, completionHandler: @escaping (ResponseResult) -> Void) {
        let datatask = self.fakeDataTask(with: request) { data, response, error in
            let responseResult = ResponseResult(data: data, response: response, error: error)
            completionHandler(responseResult)
        }
        
        datatask.resume()
    }
}
