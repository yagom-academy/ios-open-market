//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/12.
//

import Foundation

typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping DataTaskCompletionHandler
    ) -> URLSessionDataTaskProtocol
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskCompletionHandler
    ) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskCompletionHandler
    ) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
