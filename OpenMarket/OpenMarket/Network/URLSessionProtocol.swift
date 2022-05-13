//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/12.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}
