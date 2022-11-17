//
//  URLSessionDataTaskProtocol.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/16.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
    
}
