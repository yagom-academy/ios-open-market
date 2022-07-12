//
//  URLSessionDataTask+Protocol.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/07/12.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
    
}
