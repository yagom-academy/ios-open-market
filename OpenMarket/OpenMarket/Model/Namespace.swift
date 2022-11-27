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

enum OpenMarketCell {
    static let noneError = "확인 불가"
    static let soldOut = "품절"
    static let stock = "잔여수량: "
    static let list = "List"
    static let grid = "Grid"
    static let plus = "plus"
    static let cross = "chevron.right"
}
