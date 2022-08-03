//
//  URLCollection.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/12.
//

import Foundation

enum URLCollection {
    static let hostURL = "https://market-training.yagom-academy.kr/"
    case healthChecker
    case productList(pageNumber: Int, itemsPerPage: Int)
    case productDetail(productNumber: Int)
    case productPost
    case productPatch(productIdentifier: Int)
    
    var string: String {
        switch self {
        case .healthChecker:
            return "/healthChecker"
        case .productList(let pageNumber, let itemsPerPage):
            return "/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)"
        case .productDetail(let productNumber):
            return "/api/products/\(productNumber)"
        case .productPost:
            return "/api/products/"
        case .productPatch(let productIdentifier):
            return "/api/products/\(productIdentifier)"
        }
    }
}

enum VendorInfo {
    static let identifier = "fa69efb9-0335-11ed-9676-1db1453669a0"
    static let secret = "aJo1WTMl7u"
}

enum HTTPMethod {
    static let post = "POST"
    static let put = "PUT"
    static let get = "GET"
    static let delete = "DELETE"
}

enum CurrencyType {
    static let krw = "KRW"
    static let usd = "USD"
}

