//
//  StubURLSession.swift
//  OpenMarket
//
//  Created by Dylan_Y on 2022/11/18.
//

import Foundation

class StubURLSession<T: Mockable>: URLSessionProtocol {
    var isSuccess: Bool
    
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
        let sessionDataTask = StubURLSessionDataTask()
        guard let url = request.url else {
            return sessionDataTask
        }
        
        if isSuccess {
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            sessionDataTask.completion = {
                completionHandler(T.mockData, response, nil)
            }
        } else {
            let response = HTTPURLResponse(
                url: url,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )
            sessionDataTask.completion = {
                completionHandler(nil, response, nil)
            }
        }

        return sessionDataTask
    }
}

class StubURLSessionDataTask: URLSessionDataTask {
    var completion: () -> Void = { }
    
    override func resume() {
        completion()
    }
}
