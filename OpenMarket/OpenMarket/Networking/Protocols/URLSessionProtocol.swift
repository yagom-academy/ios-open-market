//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by Derrick kim on 2022/07/12.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
