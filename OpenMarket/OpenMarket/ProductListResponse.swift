//
//  ProductListResponse.swift
//  OpenMarket
//
//  Created by Baemini on 2022/11/14.
//

struct ProductListResponse: Decodable {
    let numberOfPage, itemCountInPage, totalCount, offset, limit, endOfPage: Int
    let products: [Product]
    let hasNextPage, hasPrevPage: Bool
    
    enum CodingKeys: String, CodingKey {
        case offset, limit
        case numberOfPage = "page_no"
        case itemCountInPage = "items_per_page"
        case totalCount = "total_count"
        case products = "pages"
        case endOfPage = "last_page"
        case hasNextPage = "has_next"
        case hasPrevPage = "has_prev"
    }
}
