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
