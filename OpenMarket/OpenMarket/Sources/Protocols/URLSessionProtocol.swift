//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/18.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
