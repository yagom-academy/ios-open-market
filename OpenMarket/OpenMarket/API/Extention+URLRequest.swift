//
//  Extention+URLRequest.swift
//  OpenMarket
//
//  Created by 이예원 on 2021/09/12.
//

import Foundation

enum HTTPMethods {
    case get
    case post
    case put
    case patch
    case delete
}

extension URLRequest {
    init(url: URL, method: HTTPMethods) {
        self.init(url: url)
        switch method {
        case .get:
            self.httpMethod = "GET"
        case .post:
            self.httpMethod = "POST"
        case .put:
            self.httpMethod = "PUT"
        case .patch:
            self.httpMethod = "PATCH"
        case .delete:
            self.httpMethod = "DELETE"
        }
    }
}
