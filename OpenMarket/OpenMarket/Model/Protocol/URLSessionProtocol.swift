//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/11.
//

import Foundation

struct ResponseResult {
    let data: Data?
    let response: URLResponse?
    let error: Error?
}

protocol URLSessionProtocol {
    func receiveResponse(request: URLRequest, completionHandler: @escaping (ResponseResult) -> Void)
}

extension URLSession: URLSessionProtocol {
    func receiveResponse(request: URLRequest, completionHandler: @escaping (ResponseResult) -> Void) {
        let datatask = self.dataTask(with: request) { data, response, error in
            let responseResult = ResponseResult(data: data, response: response, error: error)
            completionHandler(responseResult)
        }
        
        datatask.resume()
    }
}
