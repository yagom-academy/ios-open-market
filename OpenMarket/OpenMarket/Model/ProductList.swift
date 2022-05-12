//
//  ProductList.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/09.
//

import Foundation

enum Currency: String, Codable {
    case KRW = "KRW"
    case USD = "USD"
}

struct ProductList: Codable {
    let pageNo: Int?
    let itemsPerPage: Int?
    let totalCount: Int?
    let offset: Int?
    let limit: Int?
    let pages: [Product]?
    let lastPage: Int?
    let hasNext: Bool?
    let hasPrev: Bool?
}
