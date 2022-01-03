//
//  Product.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/03.
//

import Foundation

enum Currency: String, Decodable {
  case KRW
  case USD
}

struct Image: Decodable {
  let id: Int
  let url: String
  let thumbnailURL: String
  let succeed: Bool
  let issuedAt: String
  
  enum Codingkeys: String, CodingKey {
    case id, url, succeed
    case thumbnailURL = "thumbnail_url"
    case issuedAt = "issued_at"
  }
}

struct Vendor: Decodable {
  let id: String
  let secret: String
}

struct Product: Decodable {
  let id: Int
  let venderId: Int
  let name: String
  let thumbnail: String
  let currency: Currency
  let price: Int
  let bargainPrice: Int
  let discountedPrice: Int
  let stock: Int
  let images: [Image]
  let vendors: Vendor
  let createdAt: Date
  let issuedAt: Date
  
  enum Codingkeys: String, CodingKey {
    case id, name, thumbnail, currency, price, stock, images, vendors
    case venderId = "vendor_id"
    case bargainPrice = "bargain_price"
    case discountedPrice = "discounted_price"
    case createdAt = "created_at"
    case issuedAt = "issued_at"
  }
}

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
  
  enum Codinkeys: String, CodingKey {
    case offset, limit, pages
    case pageNumber = "page_no"
    case itemsPerPage = "item_per_page"
    case totalCount = "total_count"
    case lastPage = "last_page"
    case hasNext = "has_next"
    case hasPrevious = "has_prev"
  }
}
