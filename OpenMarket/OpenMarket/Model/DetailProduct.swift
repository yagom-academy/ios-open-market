//
//  DetailProduct.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

struct DetailProduct: Decodable {
  let id: Int
  let venderId: Int
  let name: String
  let description: String
  let thumbnail: String
  let currency: String
  let price: Int
  let bargainPrice: Int
  let discountedPrice: Int
  let stock: Int
  let images: Data
  let vendors: Data
  let createdAt: String
  let issuedAt: String
  
  private enum CodingKeys: String, CodingKey {
    case id
    case venderId = "vendor_id"
    case name
    case description
    case thumbnail
    case currency
    case price
    case bargainPrice = "bargain_price"
    case discountedPrice = "discounted_price"
    case stock
    case images
    case vendors
    case createdAt = "created_at"
    case issuedAt = "issued_at"
  }
}
