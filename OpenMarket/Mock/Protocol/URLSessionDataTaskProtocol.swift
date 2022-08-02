//
//  URLSessionDataTaskProtocol.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍. 
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
