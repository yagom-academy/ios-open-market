//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/12.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL,
                      completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
