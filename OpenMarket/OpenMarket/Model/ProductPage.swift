//
//  ProductPage.swift
//  OpenMarket
//
//  Created by 이원빈 on 2022/07/11.
//

import Foundation

struct ProductPage: Codable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offSet: Int
    let limit: Int
    let pages: [Product]
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    
    enum CodingKeys: String, CodingKey {
        case pageNo = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offSet = "off_set"
        case limit
        case pages
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
    }
}
