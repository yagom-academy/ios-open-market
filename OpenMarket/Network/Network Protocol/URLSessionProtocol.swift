//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import Foundation

typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping DataTaskCompletionHandler
    ) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping DataTaskCompletionHandler
    ) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}
