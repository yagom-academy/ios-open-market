//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by kio on 2021/06/10.
//
import Foundation

protocol MockURLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: MockURLSessionProtocol { }

