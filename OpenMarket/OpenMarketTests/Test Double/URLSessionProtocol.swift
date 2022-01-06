//
//  URLSessionProtocol.swift
//  OpenMarketTests
//
//  Created by yeha on 2022/01/06.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}
