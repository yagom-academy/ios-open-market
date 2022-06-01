//
//  ProductList.swift
//  OpenMarket
//
//  Created by Red, Mino. on 2022/05/10.
//

import Foundation

struct ProductList: Codable {
    let pageNumber: Int?
    let itemsPerPage: Int?
    let totalCount: Int?
    let offset: Int?
    let limit: Int?
    let items: [ProductDetail]?
    let lastPage: Int?
    let hasNext: Bool?
    let hasPrev: Bool?

    private enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset
        case limit
        case items = "pages"
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
    }
}
