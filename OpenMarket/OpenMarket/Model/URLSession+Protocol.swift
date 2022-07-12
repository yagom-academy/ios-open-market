//
//  URLSession+Protocol.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/07/12.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completion)
    }
}
