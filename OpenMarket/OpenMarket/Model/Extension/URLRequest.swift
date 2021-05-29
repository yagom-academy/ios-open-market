//
//  URLRequest.swift
//  OpenMarket
//
//  Created by Hailey, Ryan on 2021/05/17.
//

import Foundation

extension URLRequest {
    init(url: URL, httpMethod: HTTPMethod) {
        self.init(url: url)
        self.httpMethod = httpMethod.description
    }
}
