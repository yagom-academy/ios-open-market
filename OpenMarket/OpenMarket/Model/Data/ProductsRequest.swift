//
//  ProductsRequest.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/19.
//

import Foundation

struct ProductsRequest: APIRequest {
    var path: URLAdditionalPath = .product
    var method: HTTPMethod = .get
    var baseURL: String {
        URLHost.openMarket.url + path.value
    }
    var headers: [String : String]?
    var query: [URLQueryItem]? {
        [
            URLQueryItem(name: "page_no", value: "\(1)"),
            URLQueryItem(name: "items_per_page", value: "\(30)")
        ]
    }
    var body: Data?
}
