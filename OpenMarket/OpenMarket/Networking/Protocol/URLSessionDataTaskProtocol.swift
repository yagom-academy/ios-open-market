//
//  URLSessionDataTaskProtocol.swift
//  OpenMarket
//
//  Created by 케이, 수꿍 on 2022/07/13.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
