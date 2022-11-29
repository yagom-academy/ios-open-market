//
//  OpenMarketNetworkRequest.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import Foundation

struct HealthCheckerRequest: NetworkRequest {
    let httpMethod: HttpMethod = .get
    let urlHost: String = "https://openmarket.yagom-academy.kr"
    let urlPath: String = "/healthChecker"
    var queryParameters: [String: String] = [:]
    var httpHeader: [String: String]?
    var httpBody: Data?
}

struct ProductListRequest: NetworkRequest {
    let httpMethod: HttpMethod = .get
    let urlHost: String = "https://openmarket.yagom-academy.kr"
    let urlPath: String = "/api/products"
    var queryParameters: [String: String]
    var httpHeader: [String: String]?
    var httpBody: Data?
    
    init(pageNo: Int, itemsPerPage: Int, searchValue: String = "") {
        self.queryParameters = [
            "page_no": String(pageNo),
            "items_per_page": String(itemsPerPage)
        ]
        if !searchValue.isEmpty {
            self.queryParameters["search_value"] = String(searchValue)
        }
    }
}

struct ProductDetailRequest: NetworkRequest {
    let httpMethod: HttpMethod = .get
    let urlHost: String = "https://openmarket.yagom-academy.kr"
    let urlPath: String
    var queryParameters: [String: String] = [:]
    var httpHeader: [String: String]?
    var httpBody: Data?
    
    init(productID: Int) {
        self.urlPath = "/api/products/\(productID)"
    }
}

struct GenerateProductRequest: NetworkRequest {
    var httpMethod: HttpMethod = .post
    var urlHost: String = "https://openmarket.yagom-academy.kr"
    var urlPath: String = "/api/products"
    var queryParameters: [String: String] = [:]
    var httpHeader: [String: String]?
    var httpBody: Data?
    
    init(identifier: String) {
        self.httpHeader?["identifier"] = identifier
    }
}
