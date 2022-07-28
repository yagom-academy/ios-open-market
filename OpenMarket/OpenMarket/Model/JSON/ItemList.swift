//
//  ItemList.swift
//  OpenMarket
//
//  Created by Kiwi, Hugh on 2022/07/28.
//

struct ItemList: Codable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let pages: [Item]
    let lastPage: Int
    let hasNext: Bool
    let hasPrevious: Bool
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset = "offset"
        case limit = "limit"
        case pages = "pages"
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrevious = "has_prev"
    }
}

