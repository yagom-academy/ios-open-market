//
//  URLSessionDataTaskProtocol.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}
 
extension URLSessionDataTask: URLSessionDataTaskProtocol { }
