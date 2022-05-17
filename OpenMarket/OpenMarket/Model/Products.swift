//
//  Products.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

struct ProductsList: Decodable {
  let pageNumber: Int
  let itemsPerPage: Int
  let totalCount: Int
  let offset: Int
  let limit: Int
  let pages: [Page]
  let lastPage: Int
  let hasNext: Bool
  let hasPrev: Bool
  
  private enum CodingKeys: String, CodingKey {
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

struct Page: Decodable, Hashable {
  let id: Int
  let venderId: Int
  let name: String
  let thumbnail: String
  let currency: String
  let price: Int
  let bargainPrice: Int
  let discountedPrice: Int
  let stock: Int
  let createdAt: String
  let issuedAt: String
  
  private enum CodingKeys: String, CodingKey {
    case id
    case venderId = "vendor_id"
    case name
    case thumbnail
    case currency
    case price
    case bargainPrice = "bargain_price"
    case discountedPrice = "discounted_price"
    case stock
    case createdAt = "created_at"
    case issuedAt = "issued_at"
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: Page, rhs: Page) -> Bool {
    lhs.id == rhs.id
  }
}

