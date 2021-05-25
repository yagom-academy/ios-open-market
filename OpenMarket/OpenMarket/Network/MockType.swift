//
//  MockType.swift
//  OpenMarket
//
//  Created by steven on 2021/05/21.
//

import UIKit

protocol URLSessionProtocol {
    // 실제 URLSession에 있는 함수를 똑같이 선언!(매개변수 이름도 같게 해야함!)
    func dataTask(with resquest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class MockURLSessionDataTask: URLSessionDataTask {
    override init() {}
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
}

class MockURLSession: URLSessionProtocol {
    var sessionDataTask: MockURLSessionDataTask?
    
    func dataTask(with resquest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        // 아이템 요청 성공 응답
        let succseeResponse = HTTPURLResponse(url: URL(string: RequestAddress.readItem(id: 1).url)!, statusCode: 200, httpVersion: "2", headerFields: nil)
        
        let sessionDataTask = MockURLSessionDataTask()
        sessionDataTask.resumeDidCall = {
            completionHandler(NSDataAsset(name: "item")?.data, succseeResponse, nil)
        }
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}
