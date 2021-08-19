//
//  TestProtocol.swift
//  OpenMarket
//
//  Created by Theo on 2021/08/17.
//

import Foundation

protocol URLSessionProtocol {
    func makedDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func makedDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTaskProtocol
        
    }
    
    
}
