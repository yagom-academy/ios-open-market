//
//  URLSessionDataTaskProtocol.swift
//  OpenMarket
//
//  Created by Dasoll Park on 2021/08/11.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
