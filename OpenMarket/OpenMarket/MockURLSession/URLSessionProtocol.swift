//
//  URLSessionProtocol.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 16/11/2022.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
