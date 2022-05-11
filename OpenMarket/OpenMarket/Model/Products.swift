//
//  Products.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

struct ProductsList: Codable {
  let pageNumber: Int?
  let itemsPerPage: Int?
  let totalCount: Int?
  let offset: Int?
  let limit: Int?
  let items: [Item]
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

struct Item: Codable {
  let id: Int?
  let venderId: Int?
  let name: String?
  let thumbnail: String?
  let currency: String?
  let price: Int?
  let bargainPrice: Int?
  let discountedPrice: Int?
  let stock: Int?
  let createdAt: String?
  let issuedAt: String?
  let images: [Images]
  let vendors: Vendors?
  
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
    case images
    case vendors
  }
}

struct Images: Codable {
  let id: Int?
  let url: String?
  let thumbnailUrl: String?
  let succeed: Bool?
  let issuedAt: String?
  
  private enum CodingKeys: String, CodingKey {
    case id
    case url
    case thumbnailUrl = "thumbnail_url"
    case succeed
    case issuedAt = "issued_at"
  }
}

struct Vendors: Codable {
  let name: String?
  let id: Int?
  let createdAt: String?
  let issuedAt: String?
  
  private enum CodingKeys: String, CodingKey {
    case name
    case id
    case createdAt = "created_at"
    case issuedAt = "issued_at"
  }
}

