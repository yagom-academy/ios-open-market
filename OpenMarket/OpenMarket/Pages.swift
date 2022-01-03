//
//  Pages.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/03.
//

import Foundation

struct Page: Codable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalItemCount: Int
    let offset: Int
    let limit: Int
    let productsInPage: [Product]
    let lastPage: Int
    let hasNext: Bool
    let hasPreview: Bool
    
    private enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalItemCount = "total_count"
        case offset
        case limit
        case productsInPage = "pages"
        case lastPage = "lastPage"
        case hasNext = "has_next"
        case hasPreview = "has_prev"
    }
}
