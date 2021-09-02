//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/31.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
}
