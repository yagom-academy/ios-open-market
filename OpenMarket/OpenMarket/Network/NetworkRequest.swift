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
    case productDetail(productID: Int)
    case postData
    case patchData(productID: Int)
    case deleteDataURI(productID: Int)
    case deleteData(uri: String)
    
    var requestURL: URL? {
        switch self {
        case .checkHealth:
            return URLComponents.createURL(path: "/healthChecker",
                                         queryItem: nil)
        case .productList(let pageNo, let itemsPerPage):
            return URLComponents.createURL(path: "/api/products",
                                         queryItem: [URLQueryItem(name: "page_no",
                                                                  value: String(pageNo)),
                                                     URLQueryItem(name: "items_per_page",
                                                                  value: String(itemsPerPage))])
        case .productDetail(let id):
            return URLComponents.createURL(path: "/api/products/\(id)",
                                         queryItem: nil)
        case .postData:
            return URLComponents.createURL(path: "/api/products", queryItem: nil)
        case .patchData(let id):
            return URLComponents.createURL(path: "/api/products/\(id)", queryItem: nil)
        case .deleteDataURI(let id):
            return URLComponents.createURL(path: "/api/products/\(id)/archived", queryItem: nil)
        case .deleteData(let uri):
            return URLComponents.createURL(path: uri, queryItem: nil)
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
