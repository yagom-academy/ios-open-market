//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
    
    func dataTask(with url: URLRequest,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completion)
    }
    
    func dataTask(with urlRequest: URLRequest,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: urlRequest, completionHandler: completion)
    }
}
