//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by 홍정아 on 2021/08/11.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
