//
//  ProductList.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/04.
//

import Foundation

struct ProductList: Decodable {
  let pageNumber: Int
  let itemsPerPage: Int
  let totalCount: Int
  let offset: Int
  let limit: Int
  let pages: [Product]
  let lastPage: Int
  let hasNext: Bool
  let hasPrevious: Bool
  
  enum CodingKeys: String, CodingKey {
    case offset, limit, pages
    case pageNumber = "page_no"
    case itemsPerPage = "items_per_page"
    case totalCount = "total_count"
    case lastPage = "last_page"
    case hasNext = "has_next"
    case hasPrevious = "has_prev"
  }
}
