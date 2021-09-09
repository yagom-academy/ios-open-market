//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by 이윤주 on 2021/09/03.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }
