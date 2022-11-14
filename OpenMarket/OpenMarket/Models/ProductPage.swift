//
//  ProductPage.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/14.
//

struct ProductPage: Decodable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let pages: [Product]
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    
    private enum CodingKeys: String, CodingKey {
        case offset, limit, pages
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
    }
}
