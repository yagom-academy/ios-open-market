//
//  Product.swift
//  OpenMarket
//  Created by Lingo, Quokka
//

import Foundation

struct Product: Decodable {
  enum Currency: String, Decodable {
    case krw = "KRW"
    case usd = "USD"
  }
  
  let id: Int
  let vendorId: Int
  let name: String
  let thumbnail: String
  let currency: Currency
  let price: Int
  let bargainPrice: Int
  let discountedPrice: Int
  let stock: Int
  let createdAt: String
  let issuedAt: String
  
  private enum CodingKeys: String, CodingKey {
    case vendorId = "vendor_id"
    case bargainPrice = "bargain_price"
    case discountedPrice = "discounted_price"
    case createdAt = "created_at"
    case issuedAt = "issued_at"
    case id, name, thumbnail, currency, price, stock
  }
}
