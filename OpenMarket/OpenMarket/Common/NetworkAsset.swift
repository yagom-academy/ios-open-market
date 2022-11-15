//
//  .swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/15.
//

enum NetworkURLAsset {
    static let host = "https://openmarket.yagom-academy.kr"
    static let healthChecker = "/healthChecker"
    static let productList = "/api/products?page_no=1&items_per_page=100"
    static let productDetail = "/api/products/32"
}

enum HttpMethod {
    static let GET = "GET"
    static let POST = "POST"
    static let DELETE = "DELETE"
    static let PUT = "PUT"
}
