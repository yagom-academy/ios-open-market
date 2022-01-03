//
//  Page.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/03.
//

import Foundation

struct Page: Decodable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let products: [Product]
    let lastPage: Int
    let hasNext: Bool
    let hasPrevious: Bool

    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset, limit, products
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrevious = "has_prev"
    }
}
