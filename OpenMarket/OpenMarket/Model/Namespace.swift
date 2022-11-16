//
//  Namespace.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/16.
//

enum HTTPMethod {
    static let get: String = "GET"
    static let post: String = "POST"
    static let patch: String = "PATCH"
    static let delete: String = "DELETE"
}

enum OpenMarketURL {
    static let base: String = "https://openmarket.yagom-academy.kr"
    static let heathChecker: String = "/healthChecker"
    static let itemPage: String = "/api/products?page_no=1&items_per_page=100"
    static let product: String = "/api/products/32"
}
