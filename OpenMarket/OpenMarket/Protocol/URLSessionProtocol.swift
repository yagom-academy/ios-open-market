//
//  TestProtocol.swift
//  OpenMarket
//
//  Created by Charlotte, Hosinging on 2021/08/17.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
