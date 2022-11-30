//
//  NetworkRequest.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/15.
//

import Foundation

enum NetworkRequest {
    case checkHealth
    case productList(pageNo: Int, itemsPerPage: Int)
    case productDetail
    
    var requestURL: URL? {
        switch self {
        case .checkHealth:
            return URLComponents.createURL(path: "/healthChecker",
                                         queryItem: nil)
        case .productList(pageNo: let pageNo, itemsPerPage: let itemsPerPage):
            return URLComponents.createURL(path: "/api/products",
                                         queryItem: [URLQueryItem(name: "page_no",
                                                                  value: String(pageNo)),
                                                     URLQueryItem(name: "items_per_page",
                                                                  value: String(itemsPerPage))
                                         ])
        case .productDetail:
            return URLComponents.createURL(path: "/api/products/32",
                                         queryItem: nil)
        }
    }
}

enum HttpMethod {
    static let GET = "GET"
    static let POST = "POST"
    static let DELETE = "DELETE"
    static let PUT = "PUT"
    static let PATCH = "PATCH"
}
