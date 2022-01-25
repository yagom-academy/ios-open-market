//
//  Item.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/19.
//

import Foundation

struct Item: Codable {
  let id: Int
  let vendorId: Int
  let name: String
  let thumbnail: String
  let currency: Currency
  let price: Double
  let bargainPrice: Double
  let discountedPrice: Double
  let stock: Int
  let images: [ItemImage]?
  let vendorInfo: VendorInfo?
  let createdAt: String
  let issuedAt: String
  
  enum CodingKeys : String, CodingKey {
    case id, name, thumbnail, currency, price, stock, images
    case vendorId = "vendor_id"
    case bargainPrice = "bargain_price"
    case discountedPrice = "discounted_price"
    case vendorInfo = "vendors"
    case createdAt = "created_at"
    case issuedAt = "issued_at"
  }
  
  
  
}
