//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by SeoDongyeon on 2022/05/13.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
