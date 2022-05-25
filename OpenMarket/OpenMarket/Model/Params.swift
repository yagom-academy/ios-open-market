//
//  Params.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import Foundation

struct Params: Encodable {
  let name: String
  let price: Int
  let discountedPrice: Int
  let stock: Int
  let currency: String
  let description: String
  let secret: String
  
  private enum CodingKeys: String, CodingKey {
    case name, price, stock, currency, description, secret
    case discountedPrice = "discounted_price"
  }
}

struct ImageFile {
  let fileName: String
  let type: String
  let data: Data
}
