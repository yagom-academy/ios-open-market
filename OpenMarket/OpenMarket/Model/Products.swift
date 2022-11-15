//
//  Products.swift
//  OpenMarket
//
//  Created by Mangdi on 2022/11/15.
//

import Foundation

struct Products: Codable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let pages: [Pages]
    let lastPage: Int
    let hasNext: Bool
    let hasPrevious: Bool
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset
        case limit
        case pages
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrevious = "has_prev"
    }
}
