//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

import Foundation

protocol URLSessionProtocol {
    typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void
    func mockDataTask(with request: URLRequest, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func mockDataTask(with request: URLRequest, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
