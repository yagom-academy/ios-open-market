//
//  WebPage.swift
//  OpenMarket
//
//  Created by 케이, 수꿍 on 2022/07/11.
//

struct WebPage: Codable, Equatable {
    static func == (lhs: WebPage, rhs: WebPage) -> Bool {
        return type(of: lhs) == type(of: rhs)
    }
    
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let pages: [Product]
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset
        case limit
        case pages
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
    }
}
