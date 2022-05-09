//
//  ProductList.swift
//  OpenMarket
//
//  Created by 김태훈 on 2022/05/09.
//

import Foundation

struct ProductList: Codable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrevious: Bool
    let pages: [Product]
    
    private enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrevious = "has_prev"
        case offset, limit, pages
    }
}
