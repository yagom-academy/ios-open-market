//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by 황인우 on 2021/06/01.
//

import Foundation

public protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }
