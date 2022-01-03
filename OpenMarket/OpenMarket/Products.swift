//
//  Products.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/03.
//

import Foundation

struct Products: Codable {
    let pageNumber: Int
    let itemsPerPage: Int
    var totalCount: Int
    let offset: Int
    let limit: Int
    var pages: [String]
    var lastPage: Int
    var hasNext: Bool
    var hasPrev: Bool
    
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
