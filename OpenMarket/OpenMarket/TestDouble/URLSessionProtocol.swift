//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

import Foundation

protocol URLSessionProtocol {
    typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskCompletionHandler) { }
}
