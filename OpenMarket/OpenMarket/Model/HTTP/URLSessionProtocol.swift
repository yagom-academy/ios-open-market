//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by Kiwi, Hugh on 2022/07/13.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
