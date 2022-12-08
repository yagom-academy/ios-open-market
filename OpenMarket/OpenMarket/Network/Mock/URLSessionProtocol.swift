//
//  URLSessionProtocol.swift
//  MockTests
//
//  Created by 스톤, 로빈 on 2022/11/16.
//

import Foundation

public typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

public protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }
