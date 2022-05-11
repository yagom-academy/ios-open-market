//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/11.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
