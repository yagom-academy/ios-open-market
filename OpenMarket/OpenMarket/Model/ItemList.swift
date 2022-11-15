//
//  ItemList.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/15.
//

struct ItemList: Codable {
    let pageNo, itemsPerPage, totalCount, offset: Int
    let limit: Int
    let pages: [Item]
    let lastPage: Int
    let hasNext, hasPrev: Bool

    enum CodingKeys: String, CodingKey {
        case pageNo = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset, limit, pages
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
    }
}
