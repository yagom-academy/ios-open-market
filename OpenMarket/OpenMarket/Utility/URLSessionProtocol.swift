//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/08.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
