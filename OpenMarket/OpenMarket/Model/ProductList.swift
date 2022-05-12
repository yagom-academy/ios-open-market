//
//  ProductList.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/09.
//

import Foundation

struct ProductList: Codable {
    let pageNo: Int?
    let itemsPerPage: Int?
    let totalCount: Int?
    let offset: Int?
    let limit: Int?
    let products: [Product]?
    let lastPage: Int?
    let hasNext: Bool?
    let hasPrev: Bool?
    
    enum CodingKeys: String, CodingKey {
        case pageNo = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset, limit
        case products = "pages"
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
    }
}
