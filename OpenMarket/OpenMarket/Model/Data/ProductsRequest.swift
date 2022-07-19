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
            URLQueryItem(name: Product.page.text, value: "\(Product.page.number)"),
            URLQueryItem(name: Product.itemPerPage.text, value: "\(Product.itemPerPage.number)")
        ]
    }
    var body: Data?
}
