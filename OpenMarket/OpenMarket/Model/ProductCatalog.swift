//
//  NetWork.swift
//  OpenMarket
//
//  Created by marlang, Taeangel on 2022/05/10.
//

import Foundation

struct ProductCatalog {
    let pageno: Int?
    let itemspPerPage: Int?
    let totalCount: Int?
    let offset: Int?
    let limit: Int?
    let pages: [Product]
    
    enum CodingKeys: String, CodingKey {
        case pageno = "page_no"
        case itemspPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset
        case limit
        case pages
    }
}
