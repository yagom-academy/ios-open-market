//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

protocol URLSessionProtocol {
  func dataTask(with request: URLRequest,
                completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
