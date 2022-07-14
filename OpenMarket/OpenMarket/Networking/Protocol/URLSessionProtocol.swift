//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by 케이, 수꿍 on 2022/07/13.
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
