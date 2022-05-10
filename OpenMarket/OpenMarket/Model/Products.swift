//
//  Products.swift
//  OpenMarket
//
//  Created by Red, Mino. on 2022/05/10.
//

struct Products: Codable {
    let pageNo, itemsPerPage, totalCount, offset: Int
    let limit: Int
    let pages: [Page]
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
