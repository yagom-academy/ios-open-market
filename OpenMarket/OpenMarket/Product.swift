//
//  Product.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/03.
//

import Foundation

enum Currency: String, Codable {
  case KRW
  case USD
}

struct Image: Codable {
  let id: Int
  let url: String
  let thumbnailURL: String
  let succeed: Bool
  let issuedAt: String

  enum CodingKeys: String, CodingKey {
    case id, url, succeed
    case thumbnailURL = "thumbnail_url"
    case issuedAt = "issued_at"
  }
}

struct Vendor: Codable {
  let id: Int
  let name: String
  let secret: String?
  let createdAt: String
  let issuedAt: String

  enum CodingKeys: String, CodingKey {
    case id, name, secret
    case createdAt = "created_at"
    case issuedAt = "issued_at"
  }
}

struct Product: Codable {
  let id: Int
  let venderId: Int
  let name: String
  let thumbnail: String
  let currency: Currency
  let price: Int
  let bargainPrice: Int
  let discountedPrice: Int
  let stock: Int
  let images: [Image]?
  let vendors: Vendor?
  let createdAt: String
  let issuedAt: String
  
  enum CodingKeys: String, CodingKey {
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
