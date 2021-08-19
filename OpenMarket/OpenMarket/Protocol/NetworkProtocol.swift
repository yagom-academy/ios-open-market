//
//  NetworkProtocol.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/18.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
    
}


