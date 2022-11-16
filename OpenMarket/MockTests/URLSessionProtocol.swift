//
//  URLSessionProtocol.swift
//  MockTests
//
//  Created by 스톤, 로빈 on 2022/11/16.
//

import Foundation

typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionTask
}

extension URLSession: URLSessionProtocol { }
