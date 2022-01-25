//
//  ItemList.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/19.
//

import Foundation

struct ItemList: Codable {
  let pageNumber: Int
  let itemsPerPage: Int
  let totalCount: Int
  let offset: Int
  let limit: Int
  let lastPage: Int
  let hasNext: Bool
  let hasPrevios: Bool
  let items: [Item]
  
  enum CodingKeys : String, CodingKey {
    case offset, limit
    case pageNumber = "page_no"
    case itemsPerPage = "items_per_page"
    case totalCount = "total_count"
    case lastPage = "last_page"
    case hasNext = "has_next"
    case hasPrevios = "has_prev"
    case items = "pages"
  }
}
