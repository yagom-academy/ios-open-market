//
//  Namespace.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/16.
//

import Foundation

enum HTTPMethod {
    static let get: String = "GET"
    static let post: String = "POST"
    static let patch: String = "PATCH"
    static let delete: String = "DELETE"
}

enum OpenMarketURL {
    static let base: String = "https://openmarket.yagom-academy.kr"
    static let heathChecker: String = "/healthChecker"
}

enum OpenMarketURLComponent {
    case itemPageComponent(pageNo: Int, itemPerPage: Int)
    case productComponent(productID: Int)
    
    var url: String {
        switch self {
        case .itemPageComponent(let pageNo, let itemPerPage):
            return "/api/products?page_no=\(pageNo)&items_per_page=\(itemPerPage)"
        case .productComponent(let productID):
            return "/api/products/\(productID)"
        }
    }
}
