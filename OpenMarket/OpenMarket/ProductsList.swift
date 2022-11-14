//
//  ProductsList.swift
//  OpenMarket
//
//  Created by Jpush, Aaron on 2022/11/14.
//

import Foundation

struct ProductsList: Codable {
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let pages: [Product]
    
//    enum CodingKeys: String, CodingKey {
//       case pageNo = "page_no"
//       case itemsPerPage = "items_per_page"
//       case totalCount = "total_count"
//       case offset
//       case limit
//       case lastPage = "last_page"
//       case hasNext = "has_next"
//       case hasPrev = "has_prev"
//       case pages
//    }
}
